//  Get Account
//
data "digitalocean_account" "objDoAcct" {}

//
//  Create a droplet within a project
resource "digitalocean_droplet" "objWp" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objWp.ipv4_address
    user        = "root"
    private_key = file(format("%s%s", var.strSshPath, var.strSshPte))
  }

  //
  // make remote folders in /root/
  provisioner "remote-exec" {
    inline     = ["sudo mkdir /root/bin/"]
    on_failure = continue
  }
  //
  // copy executable files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\bin"
    destination = "/root/"
    on_failure  = continue
  }
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo chmod 700 /root/bin/aptupdate.sh", "sudo chmod 700 /root/bin/wpinstall.sh", "sudo /root/bin/mkswap.sh 8", "sudo /root/bin/aptupdate.sh"]
    on_failure = continue
  }

  //
  // possible failure
  //    aptupdate.sh
  // execute remote commands
  //    $ apt-get update
  //    $ apt-get install --assume-yes php7.2-cli php7.2-mysql php7.2-xml
  
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo /root/bin/wpinstall.sh ${data.digitalocean_account.objDoAcct.email} ${var.strDoProject} ${var.strDoDomain}"]
    on_failure = continue
  }

  //
  // possible failure
  //    wpinstall.sh
  // execute remote commands (enter Wordpress email, site, domain):
  //    $ ./bin/wpinstall.sh do4@dennislwm.anonaddy.com Izzy klix.cam

  //
  // An interactive script that runs will first prompt you for your domain.
  // * You can read more information about the OpenLiteSpeed WordPress One-Click app below:
  //    https://docs.litespeedtech.com/cloud/images/wordpress/
  //
  // On the server:
  // * The default web root is located at /var/www/html
  // * You can get the MySQL root password and MySQL WordPress user password with command:
  //    sudo cat .db_password
  // * You can get the Web Admin admin password with the following command:
  //    sudo cat .litespeed_password
  // * The WordPress Cache plugin, LSCache, is located at
  //    /var/www/html/wp-content/plugins/litespeed-cache
  // * The WordPress is located at /var/www/html
  // * The phpMyAdmin is located at /var/www/phpmyadmin
  // * A script will run that will allow you to add a domain to the web server and implement SSL.
  //
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objWp.urn]
}

//
//  Create a domain for this project
resource "digitalocean_domain" "objDomain" {
  name       = var.strDoDomain
  ip_address = digitalocean_droplet.objWp.ipv4_address
}
//
//  Add a CNAME record to redirect www
resource "digitalocean_record" "objCname" {
  domain = digitalocean_domain.objDomain.name
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

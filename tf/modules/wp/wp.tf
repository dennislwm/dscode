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
    source      = "${var.strRootPath}\\bin\\mkswap.sh"
    destination = "/root/bin/mkswap.sh"
    on_failure  = continue
  }

  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo /root/bin/mkswap.sh"]
    on_failure = continue
  }
  //
  // SSH to remote server and execute commands in the /root/ folder.
  // An interactive script that runs will first prompt you for your domain.
  //
  // On the server:
  // * The default web root is located at /var/www/html
  // * You can get the MySQL root password and MySQL WordPress user password with command:
  //    sudo cat .db_password
  // * You can get the Web Admin admin password with the following command:
  //    sudo cat .litespeed_password
  // * The WordPress Cache plugin, LSCache, is located at
  //    /var/www/html/wp-content/plugins/litespeed-cache
  // * The phpMyAdmin is located at /var/www/phpmyadmin
  // * A script will run that will allow you to add a domain to the web server and implement SSL.
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objWp.urn]
}

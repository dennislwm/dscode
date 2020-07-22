//
//  Create a droplet within a project
resource "digitalocean_droplet" "objCaprover" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objCaprover.ipv4_address
    user        = "root"
    private_key = file(format("%s%s", var.strSshPath, var.strSshPte))
  }

  //
  // make remote folders in /root/
  provisioner "remote-exec" {
    inline     = ["sudo mkdir /root/bin/", "sudo mkdir /root/${var.strDoProject}"]
    on_failure = continue
  }
  //
  // copy executable files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\bin\\"
    destination = "/root/"
    on_failure  = continue
  }
  //
  // copy data files to remote folder
  provisioner "file" {
    source      = "${var.strDataPath}\\${var.strDoProject}\\"
    destination = "/root/"
    on_failure  = continue
  }
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo /root/bin/mkswap.sh 8"]
    on_failure = continue
  }

  //
  // execute remote commands:
  //  # apt install npm
  //  # npm install -g caprover
  // if docker container is not running:
  //  # docker run -p 80:80 -p 443:443 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
  // then, ssh root to get password (default: captain42), then login to http://ipaddr:3000
  //  - update domain: klix.cam
  //  - enable HTTPS (enter email address)
  //  - force HTTPS
  //  - change password
  // alternatively, execute remote command (prompts for information):
  //  # caprover serversetup
  //  ? have you already started CapRover container on your server? Yes
  //  ? IP address of your server: 178.128.59.4
  //  ? CapRover server root domain: klix.cam
  //  ? new CapRover password (min 8 chars): xx
  //  ? valid email address to get certificate and enable HTTPS: do@d.com
  //
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objCaprover.urn]
}

//
//  Create a domain for this project
resource "digitalocean_domain" "objDomain" {
  name       = var.strDoDomain
  ip_address = digitalocean_droplet.objCaprover.ipv4_address
}
//
//  Add a CNAME record to redirect www
resource "digitalocean_record" "objCname" {
  domain = digitalocean_domain.objDomain.name
  type   = "CNAME"
  name   = "www"
  value  = "@"
}
//
//  Add a A record to redirect *
resource "digitalocean_record" "objA" {
  domain = digitalocean_domain.objDomain.name
  type   = "A"
  name   = "*"
  value  = digitalocean_droplet.objCaprover.ipv4_address
}

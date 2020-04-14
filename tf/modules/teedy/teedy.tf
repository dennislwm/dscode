//
//  Create a droplet within a project
resource "digitalocean_droplet" "objTeedy" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objTeedy.ipv4_address
    user        = "root"
    private_key = file(format("%s%s", var.strSshPath, var.strSshPte))
  }

  //
  // make remote folders in /root/
  provisioner "remote-exec" {
    inline     = ["sudo mkdir /root/bin/", "sudo mkdir /root/docker-teedy/"]
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
  // copy data files to remote folder
  provisioner "file" {
    source      = "d:\\docker\\teedy\\"
    destination = "/root/"
    on_failure  = continue
  }
  //
  // copy docker files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\docker-teedy\\docker-compose.yml"
    destination = "/root/docker-teedy/docker-compose.yml"
    on_failure  = continue
  }

  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo /root/bin/mkswap.sh"]
    on_failure = continue
  }
  provisioner "remote-exec" {
    inline     = ["cd /root/docker-teedy/", "sudo docker-compose up -d"]
    on_failure = continue
  }
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objTeedy.urn]
}

//
//  Create a domain for this project
resource "digitalocean_domain" "objDomain" {
  name       = "markit.work"
  ip_address = digitalocean_droplet.objTeedy.ipv4_address
}
//
//  Add a CNAME record to redirect www
resource "digitalocean_record" "objCname" {
  domain = digitalocean_domain.objDomain.name
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

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
    inline     = ["sudo mkdir /root/bin/", "sudo mkdir /root/${var.strDoProject}", "sudo mkdir /root/${var.strDoProject}/.caddy/"]
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
  // copy data files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\docker\\${var.strDoProject}\\Caddyfile"
    destination = "/root/${var.strDoProject}/Caddyfile"
    on_failure  = continue
  }
  //
  // copy docker files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\docker\\${var.strDoProject}\\docker-compose.yml"
    destination = "/root/${var.strDoProject}/docker-compose.yml"
    on_failure  = continue
  }

  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo /root/bin/mkswap.sh", "sudo chmod 700 /root/bin/setip.sh", "sudo /root/bin/setip.sh ${digitalocean_droplet.objTeedy.ipv4_address} ${var.strDoProject} ${var.strUserPass}"]
    on_failure = continue
  }
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["cd /root/${var.strDoProject}", "sudo docker-compose up -d"]
    on_failure = continue
  }
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objTeedy.urn]
}

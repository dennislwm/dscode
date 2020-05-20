//
//  Create a droplet within a project
resource "digitalocean_droplet" "objTinode" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objTinode.ipv4_address
    user        = "root"
    private_key = file(format("%s%s", var.strSshPath, var.strSshPte))
  }

  //
  // make remote folders in /root/
  provisioner "remote-exec" {
    inline     = ["sudo mkdir /root/bin/", "sudo mkdir /root/tinode/", "sudo mkdir /root/tinode/.caddy/", "sudo mkdir /root/tinode/mongodb/"]
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
    source      = "d:\\docker\\tinode\\"
    destination = "/root/"
    on_failure  = continue
  }
  //
  // copy data files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\tinode\\Caddyfile"
    destination = "/root/tinode/Caddyfile"
    on_failure  = continue
  }
  //
  // copy docker files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\tinode\\docker-compose.yml"
    destination = "/root/tinode/docker-compose.yml"
    on_failure  = continue
  }

  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo chmod 700 /root/bin/initdb.sh"]
    on_failure = continue
  }
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo /root/bin/mkswap.sh", "sudo /root/bin/initdb.sh"]
    on_failure = continue
  }
  //
  // SSH to remote server and execute commands in the /root/tinode/ folder.
  // This cannot be provisioned as you must login to NOIP.com and update:
  // host tinode.myvnc.com to new IP address
  //  Step 1:
  //    $ docker-compose up -d
  //
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objTinode.urn]
}

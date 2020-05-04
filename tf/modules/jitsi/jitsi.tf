//
//  Create a droplet within a project
resource "digitalocean_droplet" "objJitsi" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objJitsi.ipv4_address
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
  // This cannot be provisioned as Step 1 is a Graphical User Interface
  //  Step 1 (enter domain, ie. markit.work):
  //    $ ./01_videoconf.sh
  //  Step 2 (enter email address):
  //    $ ./02_https.sh
  //
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objJitsi.urn]
}

//
//  Create a domain for this project
resource "digitalocean_domain" "objDomain" {
  name       = var.strDoDomain
  ip_address = digitalocean_droplet.objJitsi.ipv4_address
}
//
//  Add a CNAME record to redirect www
resource "digitalocean_record" "objCname" {
  domain = digitalocean_domain.objDomain.name
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

//
//  Create a droplet within a project
resource "digitalocean_droplet" "objFold" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objFold.ipv4_address
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

  //  Welcome to your new folding@home droplet! For information on how to use the client, check out:
  //    https://foldingathome.org/support/faq/installation-guides/linux/
  //    https://foldingathome.org/support/faq/installation-guides/linux/command-line-options/
  //    https://foldingathome.org/support/faq/installation-guides/configuration-guide/
  //
  //  Currently, folding@home is running as an anonymous donor (Anonymous), for the
  //  default team (0), with no passkey, and at medium power. To configure this:
  //    sudo /etc/init.d/FAHClient stop
  //    FAHClient --configure
  //    # enter your desired configuration
  //    # copy/merge this configuration over to /etc/fahclient/config.xml
  //    sudo /etc/init.d/FAHClient start

}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objFold.urn]
}

//
//  Create a droplet within a project
resource "digitalocean_droplet" "objPynotebook" {
  image    = var.strDoImage
  name     = "${var.strDoProject}-${var.strDoRegion}-${var.strDoSize}"
  region   = var.strDoRegion
  size     = var.strDoSize
  ssh_keys = var.objSshKey

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.objPynotebook.ipv4_address
    user        = "root"
    private_key = file(format("%s%s", var.strSshPath, var.strSshPte))
  }

  //
  // make remote folders in /root/
  provisioner "remote-exec" {
    inline     = ["sudo mkdir /root/bin/", "sudo mkdir /root/${var.strDoProject}/"]
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
  // copy docker files to remote folder
  provisioner "file" {
    source      = "${var.strRootPath}\\docker\\${var.strDoProject}\\"
    destination = "/root/"
    on_failure  = continue
  }
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["sudo chmod 700 /root/bin/mkswap.sh", "sudo /root/bin/mkswap.sh 8", "sudo chmod 700 /root/bin/setip.sh", "sudo /root/bin/setip.sh ${digitalocean_droplet.objPynotebook.ipv4_address} ${var.strDoProject}"]
    on_failure = continue
  }
  //
  // execute remote commands
  provisioner "remote-exec" {
    inline     = ["cd /root/${var.strDoProject}", "sudo docker build -f Dockerfile -t ${var.strDoProject} ."]
    on_failure = continue
  }
  //
  // SSH to remote server and execute commands in the /root/ folder.
  // This cannot be provisioned as Jupyter provides a custom link
  //  Step 1:
  //    $ docker run -v /root/pynotebook:/home:rw --name objPynotebook -e DISPLAY=10.0.75.1:0.0 -p 8888:8888 -it pynotebook
  //
}

//
//  Create a project
resource "digitalocean_project" "objDoProject" {
  name      = var.strDoProject
  resources = [digitalocean_droplet.objPynotebook.urn]
}

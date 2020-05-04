provider digitalocean {
  token = var.strDoToken
}

//  Shared Resource
//  Create a new ssh key
resource "digitalocean_ssh_key" "objSshKey" {
  name       = "digitalocean ssh key"
  public_key = file(format("%s%s", var.strSshPath, var.strSshId))
}

//
//  Modules with NOIP domain
module couchdb {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //
  source = "./modules/couchdb/"
  //
  //  Declare BELOW to use GENERIC variables.tf in root folder
  //
  objSshKey   = [digitalocean_ssh_key.objSshKey.fingerprint]
  strSshPath  = var.strSshPath
  strSshPte   = var.strSshPte
  strRootPath = var.strRootPath
  strDoRegion = var.strDoRegion
  strDoSize   = var.strDoSize
}
module teedy {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //
  source = "./modules/teedy/"
  //
  //  Declare BELOW to use GENERIC variables.tf in root folder
  //
  objSshKey   = [digitalocean_ssh_key.objSshKey.fingerprint]
  strSshPath  = var.strSshPath
  strSshPte   = var.strSshPte
  strRootPath = var.strRootPath
  strDoRegion = var.strDoRegion
}

//
//  Modules with DNS domain
module jitsi {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //    strDoSize
  //
  source = "./modules/jitsi/"
  //
  //  Declare BELOW to use GENERIC variables.tf in root folder
  //
  objSshKey   = [digitalocean_ssh_key.objSshKey.fingerprint]
  strSshPath  = var.strSshPath
  strSshPte   = var.strSshPte
  strRootPath = var.strRootPath
  strDoDomain = var.strDoDomain
  strDoRegion = var.strDoRegion
}

//  Get Account
//
data "digitalocean_account" "objDoAcct" {}

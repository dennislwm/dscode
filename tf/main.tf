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
//  Modules with IP address
module fold {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //    strDoSize
  //
  source = "./modules/fold"
  //
  //  Declare BELOW to use GENERIC variables.tf in root folder
  //
  objSshKey   = [digitalocean_ssh_key.objSshKey.fingerprint]
  strSshPath  = var.strSshPath
  strSshPte   = var.strSshPte
  strRootPath = var.strRootPath
  strDoRegion = var.strDoRegion
}
module rqlite {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //
  source = "./modules/rqlite/"
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
  strDataPath = var.strDataPath
  strDoRegion = var.strDoRegion
  strDoSize   = var.strDoSize
}
module pynotebook {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //    strDoSize
  //
  source = "./modules/pynotebook/"
  //
  //  Declare BELOW to use GENERIC variables.tf in root folder
  //
  objSshKey   = [digitalocean_ssh_key.objSshKey.fingerprint]
  strSshPath  = var.strSshPath
  strSshPte   = var.strSshPte
  strRootPath = var.strRootPath
  strDataPath = var.strDataPath
  strDoDomain = var.strDoDomain
  strDoRegion = var.strDoRegion
}
module rstudio {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDataPath
  //    strDoImage
  //    strDoSize
  //
  source = "./modules/rstudio/"
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
  strDoSize   = var.strDoSize
}
module tinode {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //
  source = "./modules/tinode/"
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
module wp {
  //
  //  Override in variables.tf file in modules folder
  //    strDoProject
  //    strDoImage
  //    strDoSize
  //
  source = "./modules/wp/"
  //
  //  Declare BELOW to use GENERIC variables.tf in root folder
  //
  objSshKey   = [digitalocean_ssh_key.objSshKey.fingerprint]
  strSshPath  = var.strSshPath
  strSshPte   = var.strSshPte
  strRootPath = var.strRootPath
  strDoRegion = var.strDoRegion
}

//  Get Account
//
data "digitalocean_account" "objDoAcct" {}

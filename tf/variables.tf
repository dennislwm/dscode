//  Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
//    1. Environment variables
//    2. The terraform.tfvars file, if present.
//    3. The terraform.tfvars.json file, if present.
//    4. Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
//    5. Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

variable strDoToken {
  description = "DigitalOcean Token required for API access"
}
variable strSshPath {
  default     = "c:\\users\\denbrige\\.ssh\\"
  description = "Path to local SSH folder"
}
variable strSshId {
  default     = "id_rsa_do1.pub"
  description = "Name of local SSH public_key file"
}
variable strSshPte {
  default     = "id_rsa_do1"
  description = "Name of local SSH private_key file"
}
variable strRootPath {
  default     = "d:\\denbrige\\180 FxOption\\103 FxOptionVerBack\\083 FX-Git-Pull\\19dscode\\"
  description = "Path to local root folder"
}
variable strDoDomain {
  default     = "markit.work"
  description = "Name of custom domain (override in modules)"
}
variable strDoProject {
  default     = "Terraform Dummy Project"
  description = "Name of project per droplet (override in modules)"
}
//
//  Browse lists of images, regions, and sizes for DigitalOcean
//    URL: https://slugs.do-api.dev/
//
variable strDoImage {
  default     = "ubuntu-18-04-x64"
  description = "Image slug for droplet (override in modules)"
}
variable strDoRegion {
  default     = "sgp1"
  description = "Region for droplet (override in modules)"
}
variable strDoSize {
  default     = "s-1vcpu-1gb"
  description = "Size for droplet (override in modules)"
}

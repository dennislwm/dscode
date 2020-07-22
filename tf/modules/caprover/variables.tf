variable objSshKey {
  description = "DigitalOcean SSH Key (use default in root)"
}
variable strSshPath {
  description = "Path to local SSH folder (use default in root)"
}
variable strSshPte {
  description = "Name of local SSH private_key file (use default in root)"
}
variable strUserPass {
  description = "User and password required for NoIP.com API access"
}
variable strRootPath {
  description = "Path to local root folder (use default in root)"
}
variable strDataPath {
  description = "Path to local data folder (use default in root)"
}
variable strDoDomain {
  default     = "klix.cam"
  description = "Name of custom domain (override in modules)"
}
variable strDoProject {
  default     = "caprover"
  description = "Name of project per droplet (override in modules)"
}
variable strDoImage {
  default     = "caprover-18-04"
  description = "Image slug for droplet (override in modules)"
}
variable strDoRegion {
  description = "Region for droplet (use default in root)"
}
variable strDoSize {
  default     = "s-1vcpu-2gb"
  description = "Disk 50GB, Transfer 2TB, Price pm $10"
}

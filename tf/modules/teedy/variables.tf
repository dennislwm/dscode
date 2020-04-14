variable objSshKey {
  description = "DigitalOcean SSH Key (use default in root)"
}
variable strSshPath {
  default     = "c:\\users\\denbrige\\.ssh\\"
  description = "Path to local SSH folder"
}
variable strSshPte {
  default     = "id_rsa_do1"
  description = "Name of local SSH private_key file"
}
variable strRootPath {
  default     = "d:\\denbrige\\180 FxOption\\103 FxOptionVerBack\\083 FX-Git-Pull\\19dscode\\"
  description = "Path to local root folder"
}
variable strDoProject {
  default     = "Teedy"
  description = "Name of project per droplet (override in modules)"
}
variable strDoImage {
  default     = "docker-18-04"
  description = "Image slug for droplet (override in modules)"
}
variable strDoRegion {
  description = "Region for droplet (use default in root)"
}
variable strDoSize {
  default     = "s-2vcpu-4gb"
  description = "Size for droplet (use default in root)"
}

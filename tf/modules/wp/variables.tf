variable objSshKey {
  description = "DigitalOcean SSH Key (use default in root)"
}
variable strSshPath {
  description = "Path to local SSH folder (use default in root)"
}
variable strSshPte {
  description = "Name of local SSH private_key file (use default in root)"
}
variable strRootPath {
  description = "Path to local root folder (use default in root)"
}
variable strDoProject {
  default     = "WP"
  description = "Name of project per droplet (override in modules)"
}
variable strDoImage {
  default     = "openlitespeed-wp-18-04"
  description = "Image slug for droplet (override in modules)"
}
variable strDoRegion {
  description = "Region for droplet (use default in root)"
}
variable strDoSize {
  default     = "s-2vcpu-4gb"
  description = "Size for droplet (use default in root)"
}

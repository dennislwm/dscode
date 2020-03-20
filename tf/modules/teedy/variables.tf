variable objSshKey {
  description = "DigitalOcean SSH Key (use default in root)"
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
  description = "Size for droplet (use default in root)"
}

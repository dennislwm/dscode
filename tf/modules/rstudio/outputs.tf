output "server_ip" {
  value = digitalocean_droplet.objRstudio.ipv4_address
}

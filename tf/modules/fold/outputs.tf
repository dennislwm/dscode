output "server_ip" {
  value = digitalocean_droplet.objFold.ipv4_address
}

output "server_ip" {
  value = digitalocean_droplet.objGuacamole.ipv4_address
}

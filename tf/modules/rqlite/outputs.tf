output "server_ip" {
  value = digitalocean_droplet.objRqlite.ipv4_address
}

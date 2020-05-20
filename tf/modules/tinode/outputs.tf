output "server_ip" {
  value = digitalocean_droplet.objTinode.ipv4_address
}

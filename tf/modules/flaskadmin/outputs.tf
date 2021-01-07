output "server_ip" {
  value = digitalocean_droplet.objFlaskadmin.ipv4_address
}

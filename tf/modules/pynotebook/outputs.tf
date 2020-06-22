output "server_ip" {
  value = digitalocean_droplet.objPynotebook.ipv4_address
}

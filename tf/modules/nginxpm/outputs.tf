output "server_ip" {
  value = digitalocean_droplet.objNginxProxyManager.ipv4_address
}

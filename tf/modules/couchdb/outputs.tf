output "server_ip" {
  value = digitalocean_droplet.objCouchdb.ipv4_address
}

output "email" {
  value = data.digitalocean_account.objDoAcct.email
}
output "droplet_limit" {
  value = data.digitalocean_account.objDoAcct.droplet_limit
}
output "server_ip_caprover" {
  value = module.caprover.server_ip
}
output "server_ip_couchdb" {
  value = module.couchdb.server_ip
}
output "server_ip_flaskadmin" {
  value = module.flaskadmin.server_ip
}
output "server_ip_fold" {
  value = module.fold.server_ip
}
output "server_ip_guacamole" {
  value = module.guacamole.server_ip
}
output "server_ip_jitsi" {
  value = module.jitsi.server_ip
}
output "server_ip_pynotebook" {
  value = module.pynotebook.server_ip
}
output "server_ip_rqlite" {
  value = module.rqlite.server_ip
}
output "server_ip_teedy" {
  value = module.teedy.server_ip
}
output "server_ip_tinode" {
  value = module.tinode.server_ip
}
output "server_ip_rstudio" {
  value = module.rstudio.server_ip
}
output "server_ip_wp" {
  value = module.wp.server_ip
}

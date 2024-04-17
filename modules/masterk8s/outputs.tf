output "master_public_ip" {
  value = yandex_compute_instance.master.network_interface.0.nat_ip_address
}

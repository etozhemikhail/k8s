resource "yandex_compute_instance" "k8s-node" {
  service_account_id = yandex_iam_service_account.iac.id
  count              = 3
  name               = "${terraform.workspace}-k8s-node${count.index + 1}"
  hostname           = "${terraform.workspace}-k8s-node${count.index + 1}"
  zone               = var.zones[count.index]
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 20
      type     = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet[count.index].id
    nat       = true
  }

  metadata = {
    user-data = "${file("./user.txt")}"
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = pathexpand(var.service_account_key_file)
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

resource "yandex_compute_instance" "worker" {
  name                      = "worker"
  platform_id               = "standard-v3"
  zone                      = var.zone
  allow_stopping_for_update = true
  folder_id                 = var.folder_id
  hostname                  = "worker1-node"

  resources {
    cores         = 2
    memory        = 6
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("./user.txt")}"
  }
}

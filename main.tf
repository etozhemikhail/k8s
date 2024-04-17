#Variables

variable "service_account_key_file" {
  description = "Serivce account key file"
  type        = string
  default     = "~/key.json"
}

variable "cloud_id" {
  description = "Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "ID of the folder"
  type        = string
}

variable "image_id" {
  description = "Image ID"
  type        = string
}

variable "zone" {
  description = "Network zone"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "subnets" {
  description = "map of subnets"
  type        = map(object({ zone = string, cidr = string }))
  default = {
    "subnet-1" = { zone = "ru-central1-a", cidr = "192.168.10.0/24" }
    #    "subnet-2" = { zone = "ru-central1-b", cidr = "192.168.20.0/24" }
    #    "subnet-3" = { zone = "ru-central1-d", cidr = "192.168.30.0/24" }
  }
}

locals {
  enable_nat = true
}

#service-account

resource "yandex_iam_service_account" "iac" {
  name = "iac"
}

#Provider

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

#Network

resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet" {
  for_each       = var.subnets
  name           = each.key
  zone           = each.value.zone
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = [each.value.cidr]
}

#Compute instance group for masters

resource "yandex_compute_instance_group" "k8s-masters" {
  name               = "k8s-masters"
  service_account_id = yandex_iam_service_account.iac.id
  folder_id          = var.folder_id

  instance_template {
    name        = "master-{instance.index}"
    platform_id = "standard-v3"

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

    dynamic "network_interface" {
      for_each = yandex_vpc_subnet.k8s-subnet

      content {
        subnet_ids = [network_interface.value.id]
        nat        = local.enable_nat
      }
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      user-data = "${file("./user.txt")}"
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }
}

#Compute instance group for workers

resource "yandex_compute_instance_group" "k8s-workers" {
  name               = "k8s-workers"
  service_account_id = yandex_iam_service_account.iac.id
  folder_id          = var.folder_id

  instance_template {
    name        = "worker-{instance.index}"
    platform_id = "standard-v3"

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

    dynamic "network_interface" {
      for_each = yandex_vpc_subnet.k8s-subnet

      content {
        subnet_ids = [network_interface.value.id]
        nat        = local.enable_nat
      }
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      user-data = "${file("./user.txt")}"
    }

    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
    ]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }
}

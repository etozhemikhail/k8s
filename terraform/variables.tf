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

variable "zones" {
  description = "Network zone"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "dns_zone_id" {
  description = "DNS zone"
  type        = string
  default     = "dnse9jsjfidr66bl845d"
}

variable "cidr" {
  type = map(list(string))
  default = {
    stage = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    prod  = ["192.168.110.0/24", "192.168.120.0/24", "192.168.130.0/24"]
  }
}

/* variable "subnet_id" {
  description = "Subnet ID"
  type        = string
} */

/* variable "subnets" {
  description = "map of subnets"
  type        = map(object({ zone = string, cidr = string }))
  default = {
    "subnet-1" = { zone = "ru-central1-a", cidr = "192.168.10.0/24" }
    #    "subnet-2" = { zone = "ru-central1-b", cidr = "192.168.20.0/24" }
    #    "subnet-3" = { zone = "ru-central1-d", cidr = "192.168.30.0/24" }
  }
} */

/* locals {
  enable_nat = true
} */
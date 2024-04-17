variable "subnets" {
  description = "map of subnets"
  default = {
    "subnet-1" = { zone = "ru-central1-a", cidr = "192.168.10.0/24"}
    "subnet-2" = { zone = "ru-central1-b", cidr = "192.168.20.0/24"}
    "subnet-3" = { zone = "ru-central1-c", cidr = "192.168.30.0/24"}
  }
}

module "master" {
  source    = "./modules/masterk8s"
  zone      = var.zone
  folder_id = var.folder_id
  image_id  = var.image_id
  subnet_id = var.subnet_id
  cloud_id  = var.cloud_id
}

module "worker" {
  source    = "./modules/worker1k8s"
  zone      = var.zone
  folder_id = var.folder_id
  image_id  = var.image_id
  subnet_id = var.subnet_id
  cloud_id  = var.cloud_id
}

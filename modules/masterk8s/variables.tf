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

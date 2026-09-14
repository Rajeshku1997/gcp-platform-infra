variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary range for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary range for GKE services"
  type        = string
}

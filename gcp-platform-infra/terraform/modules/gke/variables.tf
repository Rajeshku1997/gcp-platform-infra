variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "network_id" {
  description = "VPC network ID"
  type        = string
}

variable "subnet_id" {
  description = "GKE subnet ID"
  type        = string
}

variable "pods_range_name" {
  description = "GKE pod secondary range name"
  type        = string
  default     = "pods"
}

variable "services_range_name" {
  description = "GKE service secondary range name"
  type        = string
  default     = "services"
}

variable "node_service_account" {
  description = "GKE node service account email"
  type        = string
}

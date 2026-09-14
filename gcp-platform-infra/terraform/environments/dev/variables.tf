variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "devops-vpc"
}

variable "subnet_name" {
  description = "GKE subnet name"
  type        = string
  default     = "devops-gke-subnet"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "devops-gke"
}

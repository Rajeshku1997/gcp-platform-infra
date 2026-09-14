terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }

  backend "gcs" {
    bucket = "project-76bbd5c2-25dc-4eb3-a36-terraform-state"
    prefix = "gcp-platform/dev"
  }
}

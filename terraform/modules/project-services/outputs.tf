output "enabled_services" {
  description = "GCP APIs enabled for the project"
  value = [
    google_project_service.compute.service,
    google_project_service.container.service,
    google_project_service.iam.service,
    google_project_service.iam_credentials.service,
    google_project_service.logging.service,
    google_project_service.monitoring.service,
    google_project_service.secretmanager.service
  ]
}

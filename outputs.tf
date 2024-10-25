
output "service_attachment_name" {
  description = "Name of the service attachment."
  value       = google_compute_service_attachment.service_attachment.name
}

output "service_attachment_self_link" {
  description = "Id of the service attachment."
  value       = google_compute_service_attachment.service_attachment.id
}

output "cloud_run_service_url" {
  description = "URL of the Cloud Run service."
  value       = google_cloud_run_v2_service.service.uri
}

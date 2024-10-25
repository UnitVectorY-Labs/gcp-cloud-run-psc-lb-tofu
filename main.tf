
# VPC Network

resource "google_compute_network" "vpc_network" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnetwork

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.name_prefix}-subnet"
  ip_cidr_range = "10.0.0.0/16"
  purpose       = "PRIVATE"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  project       = var.project_id
}

resource "google_compute_subnetwork" "vpc_subnet_regional_proxy" {
  name          = "${var.name_prefix}-regional-proxy-subnet"
  ip_cidr_range = "10.1.0.0/16"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  project       = var.project_id
}


resource "google_compute_subnetwork" "vpc_subnet_psc" {
  name          = "${var.name_prefix}-psc-subnet"
  ip_cidr_range = "10.2.0.0/16"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  role          = "ACTIVE"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  project       = var.project_id
}

# Cloud Run Service

resource "google_cloud_run_v2_service" "service" {
  name     = "${var.name_prefix}-service"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"


  deletion_protection = false

  template {
    containers {
      image = "gcr.io/cloudrun/hello"
    }
  }

}

# IAM Member for Unauthenticated Access

resource "google_cloud_run_service_iam_member" "noauth" {
  project  = var.project_id
  location = google_cloud_run_v2_service.service.location
  service  = google_cloud_run_v2_service.service.name

  role   = "roles/run.invoker"
  member = "allUsers"
}

# Serverless NEG

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "${var.name_prefix}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id

  cloud_run {
    service = google_cloud_run_v2_service.service.name
  }
}

# Backend Service

resource "google_compute_region_backend_service" "backend_service" {
  name                  = "${var.name_prefix}-backend-service"
  region                = var.region
  protocol              = "HTTPS"
  load_balancing_scheme = "INTERNAL_MANAGED"
  project               = var.project_id

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
}

# URL Map

resource "google_compute_region_url_map" "url_map" {
  name            = "${var.name_prefix}-url-map"
  region          = var.region
  provider        = google-beta
  default_service = google_compute_region_backend_service.backend_service.id
  project         = var.project_id
}

# SSL Policy

resource "google_compute_region_ssl_policy" "ssl_policy" {
  name            = "${var.name_prefix}-ssl-policy"
  region          = var.region
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
  project         = var.project_id
}

# Target HTTPS Proxy

resource "google_compute_region_target_https_proxy" "https_proxy" {
  name                             = "${var.name_prefix}-https-proxy"
  region                           = var.region
  url_map                          = google_compute_region_url_map.url_map.id
  certificate_manager_certificates = ["projects/${var.project_id}/locations/${var.region}/certificates/${var.certificate_name}"]
  ssl_policy                       = google_compute_region_ssl_policy.ssl_policy.id
  project                          = var.project_id
}


# Forwarding Rule

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name        = "${var.name_prefix}-forwarding-rule"
  project     = var.project_id
  provider    = google-beta
  region      = var.region
  ip_protocol = "TCP"
  port_range  = "443"
  # This is the setting I want to enable but I get an error when I do that after the initial apply.
  # allow_psc_global_access   = true
  load_balancing_scheme = "INTERNAL_MANAGED"
  network               = google_compute_network.vpc_network.name
  subnetwork            = google_compute_subnetwork.vpc_subnet.name
  target                = google_compute_region_target_https_proxy.https_proxy.id

  depends_on = [
    google_compute_subnetwork.vpc_subnet_regional_proxy,
  ]
}

# Private Service Connect Service Attachment

resource "google_compute_service_attachment" "service_attachment" {
  name                  = "${var.name_prefix}-service-attachment"
  region                = var.region
  connection_preference = "ACCEPT_MANUAL"
  target_service        = google_compute_forwarding_rule.forwarding_rule.id
  nat_subnets           = [google_compute_subnetwork.vpc_subnet_psc.id]
  enable_proxy_protocol = false
  project               = var.project_id
  reconcile_connections = true
}

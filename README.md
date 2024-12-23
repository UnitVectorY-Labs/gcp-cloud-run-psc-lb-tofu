# gcp-cloud-run-psc-lb-tofu

Demonstrates how to expose a private Cloud Run service using Private Service Connect and an internal HTTPS load balancer.

## Overview

This project demonstrates how to securely expose a Cloud Run service using Private Service Connect and an internal HTTPS load balancer. The Cloud Run service is deployed within a VPC network and is only accessible through an internal load balancer, ensuring it is not reachable from the public internet. The internal HTTPS load balancer routes traffic from the VPC network to the Cloud Run service.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_forwarding_rule.forwarding_rule](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_forwarding_rule) | resource |
| [google-beta_google_compute_region_url_map.url_map](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_url_map) | resource |
| [google_cloud_run_service_iam_member.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_cloud_run_v2_service.service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_region_backend_service.backend_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_compute_region_network_endpoint_group.serverless_neg](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |
| [google_compute_region_ssl_policy.ssl_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_ssl_policy) | resource |
| [google_compute_region_target_https_proxy.https_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_https_proxy) | resource |
| [google_compute_service_attachment.service_attachment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_service_attachment) | resource |
| [google_compute_subnetwork.vpc_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.vpc_subnet_psc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.vpc_subnet_regional_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_name"></a> [certificate\_name](#input\_certificate\_name) | Name of the Certificate Manager certificate. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for all resource names. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region to deploy resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_run_service_url"></a> [cloud\_run\_service\_url](#output\_cloud\_run\_service\_url) | URL of the Cloud Run service. |
| <a name="output_service_attachment_name"></a> [service\_attachment\_name](#output\_service\_attachment\_name) | Name of the service attachment. |
| <a name="output_service_attachment_self_link"></a> [service\_attachment\_self\_link](#output\_service\_attachment\_self\_link) | Id of the service attachment. |
<!-- END_TF_DOCS -->

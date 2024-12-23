# gcp-cloud-run-psc-lb-tofu

Demonstrates how to expose a private Cloud Run service using Private Service Connect and an internal HTTPS load balancer.

## Overview

This project demonstrates how to securely expose a Cloud Run service using Private Service Connect and an internal HTTPS load balancer. The Cloud Run service is deployed within a VPC network and is only accessible through an internal load balancer, ensuring it is not reachable from the public internet. The internal HTTPS load balancer routes traffic from the VPC network to the Cloud Run service.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

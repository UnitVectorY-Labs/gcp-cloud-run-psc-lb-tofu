variable "name_prefix" {
  description = "Prefix for all resource names."
  type        = string
}

variable "region" {
  description = "GCP region to deploy resources."
  type        = string
}

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "certificate_name" {
  description = "Name of the Certificate Manager certificate."
  type        = string
}
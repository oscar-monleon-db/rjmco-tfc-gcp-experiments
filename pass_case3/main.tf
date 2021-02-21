//--------------------------------------------------------------------
// Variables
variable "sentinel_illegal_module_environment" {}
variable "sentinel_illegal_module_organization" {}
variable "sentinel_illegal_module_service_project_id" {}

//--------------------------------------------------------------------
// Modules
module "sentinel_illegal_module" {
  source  = "app.terraform.io/rjmco/sentinel-illegal-module/google"
  version = "0.0.1+experiment.0"

  environment = "${var.sentinel_illegal_module_environment}"
  organization = "${var.sentinel_illegal_module_organization}"
  service_project_id = "${var.sentinel_illegal_module_service_project_id}"
}
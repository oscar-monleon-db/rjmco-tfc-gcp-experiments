module "pass_case4" {
  source  = "app.terraform.io/rjmco/sentinel-illegal-nested-module/google"
  version = "0.0.1+experiment.0"

  environment = var.environment
  organization = var.organization
  service_project_id = var.service_project_id
}
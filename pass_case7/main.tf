module "pass_case5" {
  source  = "app.terraform.io/rjmco/sentinel-simple-module/google"
  version = "0.0.1-experiment.1"

  environment        = var.environment
  organization       = var.organization
  service_project_id = var.service_project_id
}
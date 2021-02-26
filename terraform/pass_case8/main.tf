module "pass_case8" {
  source  = "app.terraform.io/rjmco/sentinel-nested-module/google"
  version = "0.0.1+experiment.2"

  environment        = var.environment
  organization       = var.organization
  service_project_id = var.service_project_id
}

### The following variables with be set by the TFC workspace administrators ###
variable "environment" {
  description = "Environment the service project is on. Possible values are: 'dev', 'uat' and 'prd'"
  type        = string
}

variable "organization" {
  description = "Organization the service project is on. Possible values are: 'od', 'ot,' 'op'"
}

### The following variable will be set by the user.
variable "service_project_id" {
  description = "GCP service project ID"
  type        = string
}
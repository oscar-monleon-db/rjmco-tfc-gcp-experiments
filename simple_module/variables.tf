### The following variables with be set by the TFC workspace administrators ###
variable "environment" {
  description = "Environment the service project is on. Possible values are: 'dev', 'uat' and 'prd'"
  type        = string
}

variable "host_project_ids" {
  description = "Host project IDs map. This should not be overridden."
  # The default value below is just an example, this variable should be set the same on all TFE Workspaces
  #
  # default = {
  #   "od" : {
  #     "dev" : "project-od-dev",
  #     "uat" : "project-od-uat",
  #     "prd" : "project-od-prd",
  #   },
  #   "ot" : {
  #     "dev" : "project-od-dev",
  #     "uat" : "project-od-uat",
  #     "prd" : "project-od-prd",
  #   },
  #   "op" : {
  #     "dev" : "project-od-dev",
  #     "uat" : "project-od-uat",
  #     "prd" : "project-od-prd",
  #   }
  # }
}

variable "organization" {
  description = "Organization the service project is on. Possible values are: 'od', 'ot,' 'op'"
}

variable "service_account_id" {
  description = "Application service account ID"
  type        = string
}

### The following variable will be set by the user.
variable "service_project_id" {
  description = "GCP service project ID"
  type        = string
}
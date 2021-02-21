# rjmco-tfc-gcp-experiments

Terraform Cloud /w GCP integration experiment

This repository contains Terraform code to help create mocks for the test cases of a Sentinel policy which performs the following checks:

* restrict the use of google_project_iam_member and google_compute_shared_vpc_service_project resources to the following list of allowed modules if the project being targeted by the resources is one of a list of hypothetical host projects.

```
app.terraform.io/rjmco/simple_module
app.terraform.io/rjmco/nested_module
```

## Sentinel policy specification

* The Sentinel policy should have a list of host projects that it tries to protect when two specific resource types (`google_project_iam_member` and `google_compute_shared_vpc_service_project`) are deployed. If one of these types of resources are deployed to one of the host projects, then the policy should make sure that these resources are being deployed by either the `app.terraform.io/rjmco/sentinel-simple-module/google` or a submodule of `app.terraform.io/rjmco/sentinel-nested-module/google`. If the resources are deployed to a protected host project from the root module or any other module (even if one of the allowed modules are included on the same Terraform run) the Sentinel Policy should fail.

## GCP projects setup

The following steps imply that the project is created under a folder in a GCP organization.

```
export HOST_PROJECT_ID=<...>
export SERVICE_PROJECT_ID=<...>
export FOLDER_ID=<...>
export BILLING_ACCOUNT=<...>

gcloud projects create $HOST_PROJECT_ID --folder $FOLDER_ID --no-enable-cloud-apis
gcloud projects create $SERVICE_PROJECT_ID --folder $FOLDER_ID --no-enable-cloud-apis
gcloud beta billing projects link $HOST_PROJECT_ID --billing-account $BILLING_ACCOUNT
gcloud beta billing projects link $SERVICE_PROJECT_ID --billing-account $BILLING_ACCOUNT

gcloud services enable compute.googleapis.com --project $HOST_PROJECT_ID
gcloud compute shared-vpc enable --project $HOST_PROJECT_ID
```

## Terraform Modules

* `simple_module` is a module which is available through `app.terraform.io/rjmco/sentinel-simple-module/google`. This module should be allowed by Sentinel to deploy the protected resources on any of a list of host projects;

* `illegal_module` is a module which is available through `app.terraform.io/rjmco/sentinel-illegal-module/google`. This modules should not be allowed by Sentinel to deploy the projected resources to any of a list of host projects. It should however not prevent the 

* `nested_module` is a wrapper for a sub-directory module called `simple_module` which contains the same exact code as the `simple_module`. This module is available through `app.terraform.io/rjmco/sentinel-nested-module/google`

* `illegal_nested_module` is a module which is available through `app.terraform.io/rjmco/sentinel-illegal-nested-module/google` is an exact replica of `nested_module`.

## List of test cases

The following test cases mention protected projects. Protected projects are host projects that we which to restrict modifications by restricting modifications from being deployed through specific authorized modules monitored by a Sentinel policy. This policy however does not care if the project is a host project or not, it just cares about its ID.

For the purpose of test setup, only projects on the 'od' organization are considered to be protected.

### Pass cases

* `pass_case1` tries to deploy `google_project_iam_member` on a project that is not protected from TF's root module;
* `pass_case2` tries to deploy `google_compute_shared_vpc_service_project` on a project that is not protected from TF's root module;
* `pass_case3` tries to deploy both type of resources on a project that is not protected from an invocation of `illegal_module`;
* `pass_case4` tries to deploy both type of resources on a project that is not protected from an invocation of `illegal_nested_module`;
* `pass_case5` tries to deploy both type of resources on a project that is not protected from an invocation of `simple_module`;
* `pass_case6` tries to deploy both type of resources on a project that is not protected from an invocation of `nested_module`;
* `pass_case7` tries to deploy both type of resources on a project that is protected from an invocation of `simple_module`;
* `pass_case8` tries to deploy both type of resources on a project that is protected from an invocation of `nested_module`;

### Fail cases

* `fail_case1` tries to deploy `google_project_iam_member` on one of the protected host projects from TF's root module
* `fail_case2` tries to deploy `google_compute_shared_vpc_service_project` on one of the protected host projects from TF's root module 
* `fail_case3` tries to deploy both type of resources on one of the protected projects with the `illegal_module`;
* `fail_case4` tries to deploy both type of resources on one of the protected projects with the `illegal_nested_module`;
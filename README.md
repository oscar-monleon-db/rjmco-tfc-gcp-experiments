# rjmco-tfc-gcp-experiments

Terraform Cloud & Sentinel experimentations /w GCP resources

This repository contains Terraform code which help create the mocks for test cases of a Sentinel policy which restrict the use of `google_project_iam_member` and `google_compute_shared_vpc_service_project` resources to the following list of allowed Terraform modules if the projects being targeted by the resources are one of a list of hypothetically protected host projects.

```
app.terraform.io/rjmco/sentinel-simple-module/google
app.terraform.io/rjmco/sentinel-nested-module/google
```

To help mocking scenarios where *alien* Terraform modules are used, the following Terraform modules are also used:

```
app.terraform.io/rjmco/sentinel-illegal-module/google
app.terraform.io/rjmco/sentinel-illegal-nested-module/google
```
## Sentinel policy specification

The Sentinel policy [protect-host-projects-iam-and-attachments.sentinel](sentinel/protect-host-projects-iam-and-attachments.sentinel) should have a list of host projects that it tries to protect when two specific resource types (`google_project_iam_member` and `google_compute_shared_vpc_service_project`) are deployed. If one of these types of resources are deployed to one of the host projects, then the policy should make sure that these resources are being deployed by either the `app.terraform.io/rjmco/sentinel-simple-module/google` Terraform module or the `app.terraform.io/rjmco/sentinel-nested-module/google` Terraform module, or submodules of both. If the resources are deployed to a protected host project from the root module or any other module (even if one of the allowed modules are included on the same Terraform run) the Sentinel Policy should fail.

## GCP projects setup

A simple GCP project with a permissionless service account key is all that was needed to enable Terraform Cloud to successfully generate Terraform plans and allow for the mocks to be downloaded.

All projects referenced on the code are ficticious and if they exist it is out of coincidence.

## Terraform Modules

* `simple_module` is a module which is available through `app.terraform.io/rjmco/sentinel-simple-module/google`. This module should be allowed by Sentinel to deploy the protected resources on any project on a list of protected host projects;

* `illegal_module` is a module which is available through `app.terraform.io/rjmco/sentinel-illegal-module/google`. This modules should not be allowed by Sentinel to deploy the protected resources to any project on a list of protected host projects.

* `nested_module` is a wrapper for a sub-directory module called `simple_module` which contains the same exact code as the `simple_module`. This module is available through `app.terraform.io/rjmco/sentinel-nested-module/google`. The Sentinel policy should behave in the same way with this module as it would with the `simple_module`.

* `illegal_nested_module` is a module which is available through `app.terraform.io/rjmco/sentinel-illegal-nested-module/google` is an exact replica of `nested_module`. The Sentinel policy should behave in the same way with this module as it would with the `nested_module`.

The Terraform Modules mentioned above can be found on the following GitHub repositories:

* https://github.com/rjmco/terraform-google-sentinel-simple-module
* https://github.com/rjmco/terraform-google-sentinel-nested-module
* https://github.com/rjmco/terraform-google-sentinel-illegal-module
* https://github.com/rjmco/terraform-google-sentinel-illegal-nested-module

## List of test cases

The following test cases mention protected projects. Protected projects are host projects that can only have resources deployed through specific authorized modules monitored by Sentinel policy. This policy however does not care if the project is a host project or not, it just cares about its ID.

For the purpose of test setup, only projects on the 'od' organization are considered to be protected. These have the following project IDs:

```
protected-host-project-0
protected-host-project-1
protected-host-project-2
```

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

## Terraform Cloud Generated Sentinel Mocks

Sentinel Mocks for all the above test scenarios can be found on the [sentinel/test/protect-host-projects-iam-and-attachments/ folder](sentinel/test/protect-host-projects-iam-and-attachments/).
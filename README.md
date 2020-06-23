# Terraform module and child module sample to manage Google Cloud Composer resources

[Google Cloud Composer](https://cloud.google.com/composer) is a fully managed workflow orchestration service built on Apache Airflow.

## Few notes
- /!\ Environments create Google Cloud Storage buckets that do not get cleaned up automatically on environment deletion. /!\
(https://www.terraform.io/docs/providers/google/r/composer_environment.html)

- Once the GKE Cluster is created, you'll have to manually edit the GKE Cluster to add our master authorized network
Currently there isn't any providen way to configure it with an other way.

- PS: In the parent module (variables.tf) we define allowed_ip_range list
If you still have a 403 using an allowed IP from this list, ensure you're browser isn't using an IPV6 instead of the IPV4...

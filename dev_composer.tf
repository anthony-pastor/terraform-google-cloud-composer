# /!\ Environments create Google Cloud Storage buckets that do not get cleaned up automatically on environment deletion. /!\
# https://www.terraform.io/docs/providers/google/r/composer_environment.html

# Once the GKE Cluster is created, you'll have to manually edit the GKE Cluster to add our master authorized network
# Currently there isn't any providen way to configure it with an other way.

# PS: In the parent module (variables.tf) we define allowed_ip_range list
# If you still have a 403 using an allowed IP from this list, ensure you're browser isn't using an IPV6 instead of the IPV4...

module "composer_101" {
  source          = "./modules"
  name            = "composer-101"
  region          = "europe-west1"
  zone            = "europe-west1-b"
  network         = "my-network"
  subnetwork      = "my-network-private-europe-west1"
  node_count      = 3
  disk_size_gb    = 100
  machine_type    = "n1-standard-1"
  service_account = "gsa-name@gcp-project.iam.gserviceaccount.com"
  tags            = ["tag1", "tag2", "tag3"]

  master_ipv4_cidr_block   = "10.69.48.0/28"
  cluster_ipv4_cidr_block  = "10.69.64.0/20"
  services_ipv4_cidr_block = "10.69.80.0/20"

  enable_private_endpoint = false

  image_version  = "composer-1.10.4-airflow-1.10.6"
  python_version = "3"

  airflow_config_overrides = {
    rest_api_plugin-log_loading                             = "false"
    rest_api_plugin-rest_api_plugin_http_token_header_name  = "airflow-rest-api-token"
    rest_api_plugin-filter_loading_messages_in_cli_response = "true"
    rest_api_plugin-rest_api_plugin_expected_http_token     = "xxxxxxx"
    core-dags_are_paused_at_creation                        = "true"
  }

  # To parse requirements.txt with a regexp and convert each line to map(string)
  pypi_packages = { for pair in regexall("(?P<package>[a-zA-Z0-9_-]+)(?P<version>[==<>].+)", data.local_file.requirements_txt.content) : pair.package => pair.version }
}

data "local_file" "requirements_txt" {
  filename = "${path.module}/requirements.txt"
}

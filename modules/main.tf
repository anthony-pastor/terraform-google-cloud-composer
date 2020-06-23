resource "google_composer_environment" "composer" {
  provider = google-beta
  name     = var.name
  region   = var.region
  labels   = var.labels

  config {
    node_count = var.node_count

    node_config {
      zone            = var.zone
      machine_type    = var.machine_type
      network         = var.network
      subnetwork      = var.subnetwork
      disk_size_gb    = var.disk_size_gb
      oauth_scopes    = var.oauth_scopes
      service_account = var.service_account
      tags            = var.tags

      ip_allocation_policy {
        use_ip_aliases           = true
        cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
        services_ipv4_cidr_block = var.services_ipv4_cidr_block
      }
    }

    software_config {
      image_version            = var.image_version
      python_version           = var.python_version
      pypi_packages            = var.pypi_packages
      env_variables            = var.env_variables
      airflow_config_overrides = var.airflow_config_overrides
    }

    private_environment_config {
      enable_private_endpoint    = var.enable_private_endpoint
      master_ipv4_cidr_block     = var.master_ipv4_cidr_block
      cloud_sql_ipv4_cidr_block  = var.cloud_sql_ipv4_cidr_block
      web_server_ipv4_cidr_block = var.web_server_ipv4_cidr_block
    }

    web_server_network_access_control {
      dynamic "allowed_ip_range" {
        for_each = var.allowed_ip_range

        content {
          value       = allowed_ip_range.value.value
          description = allowed_ip_range.value.description
        }
      }
    }
  }

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}

variable "name" {
  type        = string
  description = "The name of the Environment"
}

variable "region" {
  type        = string
  description = "The region"
}

variable "labels" {
  type        = map(string)
  description = "Set of labels to identify the cluster"
  default     = {}
}

variable "node_count" {
  type        = number
  description = "The number of nodes in the Kubernetes Engine cluster that will be used to run this environment. Minimal node_count is 3."
  default     = 3
}

# node_config block.
variable "zone" {
  type        = string
  description = "The Compute Engine zone in which to deploy the VMs running the Apache Airflow software, specified as the zone name or relative resource name (e.g. `projects/{project}/zones/{zone}`). Must belong to the enclosing environment's project and region."
  default     = null
}

variable "machine_type" {
  type        = string
  description = "The Compute Engine machine type used for cluster instances, specified as a name or relative resource name"
  default     = "n1-standard-1"
}

variable "network" {
  type        = string
  description = "The Compute Engine network to be used for machine communications, specified as a self-link, relative resource name (e.g. `projects/{project}/global/networks/{network}`), by name."
  default     = null
}

variable "subnetwork" {
  type        = string
  description = "The Compute Engine subnetwork to be used for machine communications, , specified as a self-link, relative resource name (e.g. `projects/{project}/regions/{region}/subnetworks/{subnetwork}`), or by name."
  default     = null
}

variable "disk_size_gb" {
  type        = number
  description = "The disk size in GB used for node VMs. Minimum size is 20GB. If unspecified, defaults to 100GB. Cannot be updated."
  default     = 100
}

variable "oauth_scopes" {
  type        = list(string)
  description = "The set of Google API scopes to be made available on all node VMs. Cannot be updated."
  default = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/compute.readonly",
    "https://www.googleapis.com/auth/devstorage.full_control",
    "https://www.googleapis.com/auth/bigquery",
    "https://www.googleapis.com/auth/datastore",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
  ]
}

variable "service_account" {
  type        = string
  description = "The service account for the cluster. The service account must have roles/composer.worker"
}

variable "tags" {
  description = "The list of instance tags applied to all node VMs. Tags are used to identify valid sources or targets for network firewalls. Each tag within the list must comply with RFC1035. Cannot be updated."
  type        = list(string)
}

# ip_allocation_policy block.
variable "cluster_ipv4_cidr_block" {
  type        = string
  description = "The IP address range used to allocate IP addresses to pods in the cluster. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. /14) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use. Specify either cluster_secondary_range_name or cluster_ipv4_cidr_block but not both."
}

variable "services_ipv4_cidr_block" {
  type        = string
  description = "The IP address range used to allocate IP addresses in this cluster. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. /14) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both."
}

# software_config block.
variable "image_version" {
  type        = string
  description = "The version of the software running in the environment. This encapsulates both the version of Cloud Composer functionality and the version of Apache Airflow. It must match the regular expression composer-[0-9]+\\.[0-9]+(\\.[0-9]+)?-airflow-[0-9]+\\.[0-9]+(\\.[0-9]+.*)?. "
  default     = "composer-1.10.4-airflow-1.10.6"
}

variable "python_version" {
  type        = string
  description = "The major version of Python used to run the Apache Airflow scheduler, worker, and webserver processes."
  default     = "3"
}

variable "pypi_packages" {
  type        = map(string)
  description = "A space separated list of pip packages to be installed"
  default     = {}
}

variable "env_variables" {
  type        = map(string)
  description = "A space separated list of env variables"
  default     = null
}

variable "airflow_config_overrides" {
  type        = map(string)
  description = "Apache Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example `core-dags_are_paused_at_creation`."
  default     = {}
}

# private_environment_config block.
variable "enable_private_endpoint" {
  type        = bool
  description = "If true, access to the public endpoint of the GKE cluster is denied."
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network. This range is used for assigning internal IP addresses to the cluster master or set of masters and to the internal load balancer virtual IP. This range must not overlap with any other ranges in use within the cluster's network."
  default     = null
}

variable "cloud_sql_ipv4_cidr_block" {
  type        = string
  description = "The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. Needs to be disjoint from web_server_ipv4_cidr_block"
  default     = null
}

variable "web_server_ipv4_cidr_block" {
  type        = string
  description = "The CIDR block from which IP range for web server will be reserved. Needs to be disjoint from master_ipv4_cidr_block and cloud_sql_ipv4_cidr_block."
  default     = null
}

variable "allowed_ip_range" {
  description = "Specifies a list of IPv4 or IPv6 ranges that will be allowed to access the Airflow web server. By default, all IPs are allowed to access the web server."
  type        = list
  default = [
    {
      value       = "118.64.103.0/23",
      description = "Infra to be whitelisted - Range #1"
    },
    {
      value       = "41.121.114.0/22",
      description = "Infra to be whitelisted - Range #2"
    },
  ]
}

variable "timeout_create" {
  type        = string
  description = "https://www.terraform.io/docs/providers/google/r/composer_environment.html#timeouts"
  default     = "1h"
}

variable "timeout_update" {
  type        = string
  description = "https://www.terraform.io/docs/providers/google/r/composer_environment.html#timeouts"
  default     = "1h"
}

variable "timeout_delete" {
  type        = string
  description = "https://www.terraform.io/docs/providers/google/r/composer_environment.html#timeouts"
  default     = "6m"
}

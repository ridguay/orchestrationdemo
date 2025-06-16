
### Variables for Notebook Mounting Secrets ### 
variable "notebook_mounting_secret_scope" {
  description = "Scope that gets created to save the secrets in."
  type        = string
}

variable "notebook_mounting_secrets" {
  description = "Secrets to create in the scope (key = secret key, value = secret value)."
  type        = map(string)
}

### Variables for Primary Cluster(s) ###
variable "cluster__unity_catalog_volume_name" {
  description = "Name of the Unity Catalog volumne."
  type        = string
}

variable "cluster__unity_catalog_volume_storage_account_name" {
  description = "Name of the storage account that contains the unity catalog volume."
  type        = string
}

variable "cluster__unity_catalog_volume_storage_container_name" {
  description = "Name of the volume storage container that contains the unity catalog volume."
  type        = string
}

variable "cluster__name" {
  description = "Names of the Databricks Unity Catalog enabled clusters (creates a separate cluster for each name specified)"
  type        = string
}

variable "cluster__spark_version_id" {
  description = "Preloaded runtime version of Databricks cluster instance"
  type        = string
  default     = "10.4.x-scala2.12" # Defaults to Spark 3.0.1 using Scala 2.12. #TODO: UC Version
}

variable "cluster__node_type_id" {
  description = "Node type ID of Databricks cluster instance"
  type        = string
}

variable "cluster__autoterminate_after_minutes" {
  description = "Number of minutes after which the cluster automatically terminates"
  type        = number
  default     = 120
}

variable "cluster__tags" {
  description = "Mapping of tags to assign to the Databricks cluster instance"
  type        = map(string)
  default     = null
}

variable "cluster__minimum_workers" {
  description = "Minimal amount of workers within the cluster"
  type        = number
}

variable "cluster__maximum_workers" {
  description = "Maximum amount of workers within the cluster"
  type        = number
}

variable "cluster__extra_spark_configuration" {
  description = "Extra spark configuration the cluster should have"
  type        = map(string)
  default     = {}
}

variable "cluster__pypi_packages" {
  description = "List of packages to install on the cluster, each item should have the format 'package==x.x.x'."
  type        = list(string)
  default     = []
}

variable "cluster__runtime_engine" {
  description = "The type of runtime engine to use. If not specified, the runtime engine type is inferred based on the spark_version value."
  type        = string
  default     = "STANDARD"
}


variable "workspace_url" {
  description = "The Databricks workspace URL"
  type        = string
  default     = ""
}

variable "env_domain" {
  description = "The env-domain combination."
  type        = string
  default     = ""
}

variable "unity_catalog_group_name" {
  description = "Entra group name for unity catalog schema / volume"
  type        = string
  default     = ""
}

variable "unity_catalog_sp_name" {
  description = "Service Principal name for unity catalog schema / volume"
  type        = string
  default     = ""
}

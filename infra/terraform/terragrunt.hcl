

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    subscription_id      = "${local.env_variables.subscription_id}"
    resource_group_name  = local.resource_group_name
    # The name of the storage account where the tfstate file will be stored
    storage_account_name = "terraformenecodemo"
    container_name       = local.container_name
    key                  = "${local.data_product}/${path_relative_to_include()}.tfstate"
  }
  disable_dependency_optimization = false
}


generate "provider_azurerm" {
  path      = "provider-azurerm.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  client_id = "${local.env_variables.client_id}"
  subscription_id = "${local.env_variables.subscription_id}"
  tenant_id = "${local.env_variables.tenant_id}"
  client_secret = var.azure_client_secret
  
  features {
    template_deployment {
      delete_nested_items_during_deletion = true
    }
  }
}
EOF
}

generate "variables" {
  path      = "variables-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "azure_client_secret" {
  type = string
  sensitive = true
}
EOF
}

locals {
  ########### INPUT CONFIGURATION START ###########

  product_configuration = yamldecode(file("_config_files/product_configuration.yaml"))
  environment_label = "eneco-demo"
  # Short label for the environment, used in resource names
  environment_label_short = "enc"
  # Name of the container in which to store the tfstate file
  env_variables = local.product_configuration["environment_variables"]
  product_variables = local.product_configuration["product_variables"]
  container_name = local.env_variables.container_name
  # The client secret is stored in the environment variable CLIENT_SECRET
  env_secrets = {
    client_secret = get_env("CLIENT_SECRET")
  }
  # Product name, used to create the tfstate file
  # and to name the resources
  data_product = local.product_configuration["product_variables"]["name"]
  resource_group_name = "eneco-demo"
  infrastructure_configuration = local.product_configuration["infrastructure_configuration"]
  # The list of DevOps engineers, used to assign roles
  data_engineers = lookup(local.product_configuration["users"]["data_engineers"], "data_engineers", {})
  # The list of Data Engineers, used to assign roles
  devops_engineers = lookup(local.product_configuration["users"]["devops_engineers"], "devops_engineers", {})
  



}

inputs = {
  # Needed for the provider
  azure_client_secret = local.env_secrets.client_secret
}

# This module is only to DRY up the configuration, it doesn't define any infrastructure,
# so skip it in the run-all commands
skip = true

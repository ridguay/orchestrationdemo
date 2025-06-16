locals {
  private_endpoint_name_prefix                    = "pe-${var.storage_account_name}"
  private_endpoint_service_connection_name_prefix = "psc-${var.storage_account_name}"
}
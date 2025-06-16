### WORKSPACE CONFIG ###
resource "databricks_token" "pat" {
  comment          = "Terraform generated. Databricks Asset Bundles deployment."
  lifetime_seconds = 31536000 # 365 days
}


resource "databricks_catalog" "uc_volume_eneco" {
  name = "uc-volume-eneco"
  comment = "Unity Catalog for eneco POC"
}

resource "databricks_schema" "uc_schema" {
  catalog_name = var.cluster__unity_catalog_volume_name
  name         = "demo_databricks_cluster"
  owner        = var.unity_catalog_sp_name
  comment      = "Comments for the schema"
  properties = {
  }
  depends_on = [ databricks_catalog.uc_volume_eneco ]
}

resource "databricks_grant" "uc_schema_permissions" {
  schema     = "${var.cluster__unity_catalog_volume_name}.${databricks_schema.uc_schema.name}"
  principal  = var.unity_catalog_group_name
  privileges = ["USE_SCHEMA", "READ VOLUME"]
  depends_on = [databricks_grant.uc_sp_permissions]
}

resource "databricks_grant" "uc_sp_permissions" {
  schema     = "${var.cluster__unity_catalog_volume_name}.${databricks_schema.uc_schema.name}"
  principal  = var.unity_catalog_sp_name
  privileges = ["USE SCHEMA", "ALL PRIVILEGES", "MANAGE"]

}

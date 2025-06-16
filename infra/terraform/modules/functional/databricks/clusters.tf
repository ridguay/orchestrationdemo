resource "databricks_cluster" "dbc" {

  cluster_name                 = var.cluster__name
  spark_version                = var.cluster__spark_version_id
  node_type_id                 = var.cluster__node_type_id
  autotermination_minutes      = var.cluster__autoterminate_after_minutes
  custom_tags                  = var.cluster__tags
  is_pinned                    = true
  enable_local_disk_encryption = true
  data_security_mode           = "USER_ISOLATION"
  runtime_engine               = var.cluster__runtime_engine
  autoscale {
    min_workers = var.cluster__minimum_workers
    max_workers = var.cluster__maximum_workers
  }

  spark_conf = merge({
    "spark.databricks.delta.properties.defaults.enableChangeDataFeed" : true,
    "spark.databricks.delta.preview.enabled" : true,
    "spark.sql.legacy.parquet.int96RebaseModeInRead" : "CORRECTED"
  }, var.cluster__extra_spark_configuration)

  spark_env_vars = {
    "PYSPARK_PYTHON" : "/databricks/python3/bin/python3",
  }

  cluster_log_conf {
    dbfs {
      destination = "dbfs:/FileStore/cluster-logs"
    }
  }

}


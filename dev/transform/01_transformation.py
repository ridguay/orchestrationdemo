# Databricks notebook source
from pyspark.sql import functions as F, Window

# Load Delta tables
airports = spark.table("airports_db.airports")
countries = spark.table("airports_db.countries")
runways = spark.table("airports_db.runways")

# Join tables
runways_joined = (
    runways.join(airports, runways.airport_ref == airports.id, "inner")
           .join(countries, airports.iso_country == countries.code, "inner")
)

# Window specs
window_long = Window.partitionBy("code").orderBy(F.desc("length_ft"))
window_short = Window.partitionBy("code").orderBy(F.asc("length_ft"))

# Longest runway per country
longest = (
    runways_joined.withColumn("rank_long", F.row_number().over(window_long))
                  .filter(F.col("rank_long") == 1)
                  .select(
                      F.col("code").alias("country_code"),
                      F.col("name").alias("country_name"),
                      F.col("airport_ref"),
                      F.col("length_ft"),
                      F.col("width_ft")
                  )
                  .withColumn("type", F.lit("longest"))
)

# Shortest runway per country
shortest = (
    runways_joined.withColumn("rank_short", F.row_number().over(window_short))
                  .filter(F.col("rank_short") == 1)
                  .select(
                      F.col("code").alias("country_code"),
                      F.col("name").alias("country_name"),
                      F.col("airport_ref"),
                      F.col("length_ft"),
                      F.col("width_ft")
                  )
                  .withColumn("type", F.lit("shortest"))
)

# Combine longest and shortest
runway_summary = longest.union(shortest)

# Save as Delta table
runway_summary.write.format("delta").mode("overwrite").saveAsTable("airports_db.runway_summary")

# Compute airport counts per country
airport_counts = (
    airports.join(countries, airports.iso_country == countries.code, "inner")
            .groupBy("code", "name")
            .agg(F.count("id").alias("airport_count"))
)

# Top 3 countries
top3 = airport_counts.orderBy(F.desc("airport_count")).limit(3)
top3.write.format("delta").mode("overwrite").saveAsTable("airports_db.top3_airports")

# Bottom 10 countries
bottom10 = airport_counts.orderBy(F.asc("airport_count")).limit(10)
bottom10.write.format("delta").mode("overwrite").saveAsTable("airports_db.bottom10_airports")

print("✅ Transform job completed successfully.")

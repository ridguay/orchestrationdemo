# Source URL
airports_url = "https://sacodeassessment.blob.core.windows.net/public/airports.csv"
countries_url = "https://sacodeassessment.blob.core.windows.net/public/countries.csv"
runways_url = "https://sacodeassessment.blob.core.windows.net/public/runways.csv"

# Save as Delta tables
df_airports = (spark.read.option("header", True)
               .option("inferSchema", True)
               .csv(airports_url))
df_airports.write.format("delta").mode("overwrite").saveAsTable("airports_db.airports")

df_countries = (spark.read.option("header", True)
                .option("inferSchema", True)
                .csv(countries_url))
df_countries.write.format("delta").mode("overwrite").saveAsTable("airports_db.countries")

df_runways = (spark.read.option("header", True)
              .option("inferSchema", True)
              .csv(runways_url))
df_runways.write.format("delta").mode("overwrite").saveAsTable("airports_db.runways")

print("Ingestion complete. Data saved as Delta tables in the airports_db database.")

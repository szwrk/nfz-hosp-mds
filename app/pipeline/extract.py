from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .getOrCreate()

jdbc_url = "jdbc:postgresql://192.168.0.102:5432/datamart"
properties = {
    "user": "sysdwh",
    "password": "oracle",
    "driver": "org.postgresql.Driver"
}

try:
    df = spark.read.jdbc(url=jdbc_url, table="(SELECT current_date) AS test", properties=properties)
    df.show()
except Exception as e:
    print("❌ Connection failed:", e)
else:
    print("✅ Connection successful")
finally:
    spark.stop()

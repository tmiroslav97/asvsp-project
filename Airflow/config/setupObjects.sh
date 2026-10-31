#!/bin/bash

# Set up connections
echo ">>> Setting up Airflow connections"

airflow connections add 'AIRFLOW_DB_CONNECTION' \
    --conn-json '{
        "conn_type": "postgres",
        "login": "airflow",
        "password": "airflow",
        "host": "postgres",
        "port": 5432,
        "schema": "airflow"
    }'

airflow connections add 'HDFS_CONNECTION' \
    --conn-json '{
        "conn_type": "webhdfs",
        "login": "hadoop",
        "host": "namenode",
        "port": 9870,
        "extra": {
            "use_ssl": false,
            "default_fs": "hdfs://namenode:9000"
        }
    }'

airflow connections add 'SPARK_CONNECTION' \
  --conn-json '{
    "conn_type": "spark",
    "host": "spark://spark-master",
    "port": 7077
  }'

airflow connections add 'MONGO_CONNECTION' \
  --conn-json '{
    "conn_type": "mongo",
    "host": "mongodb",
    "port": 27017,
    "login": "admin",
    "password": "admin"
  }'

airflow connections add 'LOCAL_FS_FILES' \
    --conn-json '{
        "conn_type": "fs",
        "extra": "{ \"path\": \"/opt/airflow/files\"}"
    }'

# Set up variables
echo ">> Setting up airflow variables"
airflow variables set MONGO_URI "mongodb://admin:admin@mongodb:27017"

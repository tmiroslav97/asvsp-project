#!/bin/bash

echo "> Starting up cluster"

read -p "> Restore Metabase database? [y/N] " -n 1 -r
echo

echo "> Creating docker network 'asvsp-project'"
docker network create asvsp-project

echo ">> Starting up HDFS"
docker compose -f Hadoop/docker-compose.yml up -d

echo ">> Starting up Apache Spark"
docker compose -f Spark/docker-compose.yml up -d

echo ">> Starting up MongoDB"
docker compose -f MongoDB/docker-compose.yml up -d

echo ">> Starting up Metabase"
docker compose -f Metabase/docker-compose.yml up -d

echo ">> Starting up Airflow"
docker compose -f Airflow/docker-compose.yml up -d

sleep 25

echo "> Setting up services"

echo ">> Setting up Airflow objects"
cmd='bash -c "/opt/airflow/config/setupObjects.sh"'
docker exec -it airflow-airflow-webserver-1 $cmd

if [[ $REPLY =~ ^[Yy]$ ]]
then
    sleep 60
    echo ">> Restoring Metabase database"
    cmd='bash -c "/config/restoreDB.sh"'
    docker exec -it mb-postgres $cmd
fi

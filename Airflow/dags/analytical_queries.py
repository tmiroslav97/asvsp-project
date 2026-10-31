from datetime import datetime

from airflow.sdk import BaseHook, Variable, dag
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator


MONGO_CONNECTOR = "org.mongodb.spark:mongo-spark-connector_2.13:11.1.0"


@dag(
    dag_id="analytical_queries",
    description="DAG in charge of running queries on top of transformed data.",
    start_date=datetime(2025, 12, 28),
    max_active_runs=1,
    catchup=False,
)
def analytical_queries():
    hdfs_default_fs = BaseHook.get_connection(
        "HDFS_CONNECTION"
    ).extra_dejson["default_fs"]
    mongo_uri = Variable.get("MONGO_URI")

    def mongo_job(task_id, application, hdfs_path):
        return SparkSubmitOperator(
            task_id=task_id,
            application=f"/opt/airflow/files/spark/analytical_jobs/{application}",
            conn_id="SPARK_CONNECTION",
            verbose=False,
            conf={"spark.jars.packages": MONGO_CONNECTOR},
            application_args=[f"{hdfs_default_fs}/transformed_data/{hdfs_path}", mongo_uri, "analytical"],
        )

    packets_per_day = mongo_job("packets_per_day", "packets_per_day.py", "packets")
    top_source_ips = mongo_job("top_source_ips", "top_source_ips.py", "ip_flows")
    top_destination_ips = mongo_job("top_destination_ips", "top_destination_ips.py", "ip_flows")
    protocol_distribution = mongo_job("protocol_distribution", "protocol_distribution.py", "ip_flows")
    avg_packet_size = mongo_job("avg_packet_size", "avg_packet_size.py", "ip_flows")
    top_destination_ports = mongo_job("top_destination_ports", "top_destination_ports.py", "transport_flows")
    dns_query_frequency = mongo_job("dns_query_frequency", "dns_query_frequency.py", "dns_queries")
    dns_ttl_stability = mongo_job("dns_ttl_stability", "dns_ttl_stability.py", "dns_answers")

    (
        packets_per_day
        >> top_source_ips
        >> top_destination_ips
        >> protocol_distribution
        >> avg_packet_size
        >> top_destination_ports
        >> dns_query_frequency
        >> dns_ttl_stability
    )


analytical_queries()

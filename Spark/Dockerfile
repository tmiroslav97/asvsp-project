FROM apache/spark:4.2.0-java17

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip curl netcat-openbsd \
    && python3 -m pip install --no-cache-dir 'numpy>=1.23,<3' \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/hadoop-conf \
    && ln -s /opt/spark /spark

# Bundle the MongoDB connector used by the analytics DAGs so executors do not need Maven access when a job starts.
RUN mkdir -p /tmp/ivy \
    && /opt/spark/bin/spark-submit \
      --conf spark.jars.ivy=/tmp/ivy \
      --packages org.mongodb.spark:mongo-spark-connector_2.13:11.1.0 \
      --class org.apache.spark.examples.SparkPi \
      /opt/spark/examples/jars/spark-examples_2.13-4.2.0.jar 1 \
    && cp /tmp/ivy/jars/*.jar /opt/spark/jars/ \
    && rm -rf /tmp/ivy

COPY config/core-site.xml /opt/hadoop-conf/core-site.xml
COPY config/spark-defaults.conf /opt/spark/conf/spark-defaults.conf

ENV HADOOP_CONF_DIR=/opt/hadoop-conf \
    PYSPARK_PYTHON=python3

USER spark

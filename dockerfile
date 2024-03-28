# Dockerfile
FROM ubuntu:16.04
# Install jdk 
RUN apt-get update && apt-get install openjdk-8-jre -y 
# Unzip kafka zip and rename at kafka
ENV kafka_version=2.13-3.7.0
ADD ./kafka_${kafka_version}.tgz ./
RUN mv kafka_${kafka_version} /opt/kafka
RUN /opt/kafka/bin/kafka-storage.sh format -t azgB17mFT8if8tYAPn4y6Q -c /opt/kafka/config/kraft/server.properties
ADD ./jaas.config /opt/kafka/config/kraft/
ENV KAFKA_HEAP_OPTS=-"Xms1G -Xmx1G"
ENV KAFKA_OPTS="-Djava.security.auth.login.config=/opt/kafka/config/kraft/jaas.config"

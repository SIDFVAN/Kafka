# Kafka BP test commands

docker stack deploy -c compose_Confluent_SSASL_test.yml KafkaS --detach=false



```console
 bash /opt/kafka/bin/kafka-acls.sh --bootstrap-server 144.178.108.18:40208  --command-config ./admin.config  --add --allow-principal User:student1 --operation All --topic student1 --resource-pattern-type prefixed
```

 Adding ACLs for resource `ResourcePattern(resourceType=TOPIC, name=student1, patternType=PREFIXED)`: 
        (principal=User:student1, host=*, operation=ALL, permissionType=ALLOW)

```console
bash /opt/kafka/bin/kafka-topics.sh --bootstrap-server 144.178.108.18:40208 --create --topic student1MijnTopic1 --partitions 1 --replication-factor 1 --command-config ./student1.config
```

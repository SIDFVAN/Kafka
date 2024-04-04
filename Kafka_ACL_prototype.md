# Prototype ACL on Kafka cluster

## sources

<https://medium.com/@azsecured/install-kafka-cluster-kraft-with-sasl-plaintext-and-acl-configs-ae01a1e0040d>

<https://jaceklaskowski.gitbooks.io/apache-kafka/content/kafka-tools-kafka-acls.html>

https://supergloo.com/kafka-tutorials/kafka-acl/?utm_content=cmp-true



## 3 node cluster kafka manual installation

Kafka version: 3.5.
OS: CentOS 9
3 nodes in one network

### Update OS and Install Java 11

``` console
sudo dnf update
sudo dnf install java-11-openjdk
```

### Install Apache

```console
sudo wget https://downloads.apache.org/kafka/3.5.2/kafka_2.13-3.5.2.tgz
sudo tar -xvf kafka_2.13-3.5.2.tgz
sudo mv kafka_2.13-3.5.2 kafka
sudo mv kafka /opt
```

### config OS

```console
su - 
sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
setenforce 0
systemctl disable — now firewalld
mkdir /opt/kafka/data
mkdir /opt/kafka/logs_metadata
cd /opt/kafka/config/kraft/
mv server.properties server.properties.org

```

### Kafka config

#### server.properties

```console
nano /opt/kafka/config/kraft/server.properties
```

```ini
node.id=1
num.network.threads=3
num.io.threads=8
log.dirs=/opt/kafka/data
metadata.log.dir=/opt/kafka/logs_metadata
 
 
process.roles=broker,controller
listeners=BROKER://172.16.0.3:9094,CONTROLLER://172.16.0.3:9095
advertised.listeners=BROKER://172.16.0.3:9094
listener.security.protocol.map=BROKER:SASL_PLAINTEXT,CONTROLLER:SASL_PLAINTEXT
controller.quorum.voters=1@172.16.0.3:9095
 
inter.broker.listener.name=BROKER
controller.listener.names=CONTROLLER
 
sasl.enabled.mechanisms=PLAIN
sasl.mechanism.controller.protocol=PLAIN
sasl.mechanism.inter.broker.protocol=PLAIN
 
authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
allow.everyone.if.no.acl.found=false
super.users=User:admin
 
delete.topic.enable=true
socket.send.buffer.bytes=1048576
socket.receive.buffer.bytes=1048576
socket.request.max.bytes=104857600
 
num.partitions=3
default.replication.factor=2
min.insync.replicas=2
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
auto.create.topics.enable=true
unclean.leader.election.enable=false

```

#### Generate Kafka cluster ID

```console
$ bash /opt/kafka/bin/kafka-storage.sh random-uuid
oQo8QZP1RQiREnIknsb6pA
```

Use the same Kafka cluster ID on each node

```console
sudo bash /opt/kafka/bin/kafka-storage.sh format -t oQo8QZP1RQiREnIknsb6pA -c /opt/kafka/config/kraft/server.properties
```

#### jaas.config

```console
nano /opt/kafka/config/kraft/jaas.config
 
KafkaServer {
 org.apache.kafka.common.security.plain.PlainLoginModule required
 username="admin"
 password="admin"
 user_admin="admin"
 user_usera="usera"
 user_userb="userb";
};
```

```console
nano /opt/kafka/config/kraft/admin.config
 
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="admin";
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN

```

#### set env variables

```console
export KAFKA_HEAP_OPTS=-"Xms1G -Xmx1G"
export KAFKA_OPTS="-Djava.security.auth.login.config=/opt/kafka/config/kraft/jaas.config"

```

export KAFKA_HEAP_OPTS=-"Xms1G -Xmx1G"
export KAFKA_OPTS="-Djava.security.auth.login.config=~/kafka/config/kraft/jaas.config"

#### start kafka nodes

```console
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties
```

## set and test ACLs security poc

### Create Kafka Topic

```console
$ bash /opt/kafka/bin/kafka-topics.sh --bootstrap-server 172.16.0.4:9092 --create --topic newtopic --partitions 2 --replication-factor 2 --command-config /opt/kafka/config/kraft/admin.config

Created topic newtopic.
```

### Grant access to user for topic: (Operation can be: All,Read,Write etc..)

```console
$ bash /opt/kafka/bin/kafka-acls.sh --bootstrap-server 172.16.0.4:9092 --command-config /opt/kafka/config/kraft/admin.config --add --allow-principal User:usera --operation All --topic newtopic

Adding ACLs for resource `ResourcePattern(resourceType=TOPIC, name=newtopic, patternType=LITERAL)`:
        (principal=User:usera, host=*, operation=ALL, permissionType=ALLOW)
```

### Remove access of user from topic

```console
$ bash /opt/kafka/bin/kafka-acls.sh --bootstrap-server 172.16.0.4:9092 --command-config /opt/kafka/config/kraft/admin.config --remove --allow-principal User:usera --operation Write --topic newtopic

Are you sure you want to remove ACLs: 
        (principal=User:usera, host=*, operation=WRITE, permissionType=ALLOW) 
 from resource filter `ResourcePattern(resourceType=TOPIC, name=newtopic, patternType=LITERAL)`? (y/n)
y
 Current ACLs for resource `ResourcePattern(resourceType=TOPIC, name=newtopic, patternType=LITERAL)`: 
        (principal=User:usera, host=*, operation=ALL, permissionType=ALLOW)
```

### Grant access to user for read from consumer group

```console
$ bash /opt/kafka/bin/kafka-acls.sh --bootstrap-server 172.16.0.4:9092 --command-config /opt/kafka/config/kraft/admin.config --add --allow-principal User:admin --operation All --topic newtopic --group 'consumergroupname'

Adding ACLs for resource `ResourcePattern(resourceType=TOPIC, name=newtopic, patternType=LITERAL)`: 
        (principal=User:admin, host=*, operation=ALL, permissionType=ALLOW)

Adding ACLs for resource `ResourcePattern(resourceType=GROUP, name=consumergroupname, patternType=LITERAL)`: 
        (principal=User:admin, host=*, operation=ALL, permissionType=ALLOW)

Current ACLs for resource `ResourcePattern(resourceType=TOPIC, name=newtopic, patternType=LITERAL)`: 
        (principal=User:admin, host=*, operation=ALL, permissionType=ALLOW)
        (principal=User:usera, host=*, operation=ALL, permissionType=ALLOW)

Current ACLs for resource `ResourcePattern(resourceType=GROUP, name=consumergroupname, patternType=LITERAL)`:
        (principal=User:admin, host=*, operation=ALL, permissionType=ALLOW)
```

### Create Consumer Group for topic

```console
$ bash /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server 172.16.0.4:9092 --topic newtopic --from-beginning --group consumergroupname --consumer.config /opt/kafka/config/kraft/admin.config

Processed a total of 0 messages
```

### List all ACLs:

```console
$ bash /opt/kafka/bin/kafka-acls.sh --bootstrap-server 172.16.0.4:9092 --list --command-config /opt/kafka/config/kraft/admin.config

Current ACLs for resource `ResourcePattern(resourceType=TOPIC, name=newtopic, patternType=LITERAL)`: 
        (principal=User:admin, host=*, operation=ALL, permissionType=ALLOW)
        (principal=User:usera, host=*, operation=ALL, permissionType=ALLOW)

Current ACLs for resource `ResourcePattern(resourceType=GROUP, name=consumergroupname, patternType=LITERAL)`:
        (principal=User:admin, host=*, operation=ALL, permissionType=ALLOW)
```

### usera can only create/alter topics with name usera_*

### set resource restrictions on a topic 



## Client connect ?


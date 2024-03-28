# Create Kafka KRaft Installation with Docker Swarm for BP2024



## Build Kafka Docker Image

### Install Docker on CentOS Node 1

```console
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

```console
sudo groupadd docker
sudo usermod -aG docker bp2024
newgrp docker
sudo nano /etc/docker/deamon.json
```

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

```console
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker

Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.
```
### Disable firewall Node 1

sudo systemctl stop firewalld
sudo systemctl disable firewalld

### Install Docker on CentOS Node 2

```console
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

```console
sudo groupadd docker
sudo usermod -aG docker bp2024
newgrp docker
sudo nano /etc/docker/deamon.json
```

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

```console
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker

Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service.
```



### Create kafka docker image
download kafka
wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
Create docker file

```dockerfile
# Dockerfile
FROM ubuntu:16.04
# Install jdk 
RUN apt-get update && apt-get install openjdk-8-jre -y 
# Unzip kafka zip and rename at kafka
ENV kafka_version=2.13-3.7.0
ADD ./kafka_${kafka_version}.tgz ./
RUN mv kafka_${kafka_version} /opt/kafka
RUN /opt/kafka/bin/kafka-storage.sh format -t azgB17mFT8if8tYAPn4y6Q -c /opt/kafka/config/kraft/server.properties

```


```console
docker build -t kafkabp2024:1.1 .
[bp2024@control Kafka]$ docker build -t kafkabp2024:1.1 .
[+] Building 46.7s (9/9) FINISHED                                                                                                                                                               docker:default 
 => [internal] load build definition from dockerfile                                                                                                                                                      0.0s 
 => => transferring dockerfile: 339B                                                                                                                                                                      0.0s 
 => [internal] load metadata for docker.io/library/ubuntu:16.04                                                                                                                                           1.9s 
 => [internal] load .dockerignore                                                                                                                                                                         0.0s 
 => => transferring context: 2B                                                                                                                                                                           0.0s 
 => [1/4] FROM docker.io/library/ubuntu:16.04@sha256:1f1a2d56de1d604801a9671f301190704c25d604a416f59e03c04f5c6ffee0d6                                                                                     6.7s 
 => => resolve docker.io/library/ubuntu:16.04@sha256:1f1a2d56de1d604801a9671f301190704c25d604a416f59e03c04f5c6ffee0d6                                                                                     0.0s
 => => sha256:da8ef40b9ecabc2679fe2419957220c0272a965c5cf7e0269fa1aeeb8c56f2e1 528B / 528B                                                                                                                0.6s
 => => sha256:1f1a2d56de1d604801a9671f301190704c25d604a416f59e03c04f5c6ffee0d6 1.42kB / 1.42kB                                                                                                            0.0s
 => => sha256:a3785f78ab8547ae2710c89e627783cfa7ee7824d3468cae6835c9f4eae23ff7 1.15kB / 1.15kB                                                                                                            0.0s
 => => sha256:b6f50765242581c887ff1acc2511fa2d885c52d8fb3ac8c4bba131fd86567f2e 3.36kB / 3.36kB                                                                                                            0.0s
 => => sha256:58690f9b18fca6469a14da4e212c96849469f9b1be6661d2342a4bf01774aa50 46.50MB / 46.50MB                                                                                                          3.5s
 => => sha256:b51569e7c50720acf6860327847fe342a1afbe148d24c529fb81df105e3eed01 857B / 857B                                                                                                                0.5s
 => => sha256:fb15d46c38dcd1ea0b1990006c3366ecd10c79d374f341687eb2cb23a2c8672e 170B / 170B                                                                                                                1.0s
 => => extracting sha256:58690f9b18fca6469a14da4e212c96849469f9b1be6661d2342a4bf01774aa50                                                                                                                 3.0s
 => => extracting sha256:b51569e7c50720acf6860327847fe342a1afbe148d24c529fb81df105e3eed01                                                                                                                 0.0s
 => => extracting sha256:da8ef40b9ecabc2679fe2419957220c0272a965c5cf7e0269fa1aeeb8c56f2e1                                                                                                                 0.0s
 => => extracting sha256:fb15d46c38dcd1ea0b1990006c3366ecd10c79d374f341687eb2cb23a2c8672e                                                                                                                 0.0s
 => [internal] load build context                                                                                                                                                                         1.5s
 => => transferring context: 119.05MB                                                                                                                                                                     1.4s
 => [2/4] RUN apt-get update && apt-get install openjdk-8-jre -y                                                                                                                                         33.6s
 => [3/4] ADD ./kafka_2.13-3.7.0.tgz ./                                                                                                                                                                   1.4s
 => [4/4] RUN mv kafka_2.13-3.7.0 kafka                                                                                                                                                                   0.4s
 => exporting to image                                                                                                                                                                                    2.4s
 => => exporting layers                                                                                                                                                                                   2.4s
 => => writing image sha256:d95165fabb68fad2ccb62c4558733286c63d40acef397ac72465f7fac1cdd410                                                                                                              0.0s
 => => naming to docker.io/library/kafkabp2024:1.0                                                                                                                                                        0.0s
[bp2024@control Kafka]$ 
```

Image is build locally

### Upload kafka docker image to Docker Hub

```console
docker tag docker.io/library/kafkabp2024:1.1 frankv72/bp2024:1.1

```

create repo on docker hub

![Docker Repo](image.png)

```console
docker login docker.io
docker push frankv72/bp2024:1.1

The push refers to repository [docker.io/frankv72/bp2024]

```

## Set up Docker Swarm
Create 3  VMs in VirtualBoxVM (node1, node2, node3)
Install docker in node1, node2 and node3.
(We plan to create docker swarm using node1, node2)

Step 1: Let’s make node1 as swarm manager

```console
ssh bp2024@172.16.0.3
[bp2024@node1 ~]$

[bp2024@node1 ~]$ docker swarm init
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on different interfaces (10.0.2.15 on enp0s3 and 172.16.0.3 on enp0s8) - specify one with --advertise-addr
[bp2024@node1 ~]$ docker swarm init --advertise-addr 172.16.0.3
Swarm initialized: current node (b0vxtj6gwr42pxprruskc928d) is now a manager.
To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-1xp48hce8actwhm8xm8bcpnlytw1w08ylo2k3sfp1pho1wyqou-7wkuamavf2b7wh9p77ytujjzg 172.16.0.3:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Step 2: Let’s make node2 as swarm worker

ssh bp2024@172.16.0.4
[bp2024@node2 ~]$ 

node2 > docker swarm join --token SWMTKN-1-1xp48hce8actwhm8xm8bcpnlytw1w08ylo2k3sfp1pho1wyqou-7wkuamavf2b7wh9p77ytujjzg 172.16.0.3:2377
This node joined a swarm as a worker.



## Create Docker Swarm 2 nodes

![Kafka setup](image-1.png)

No zookeeper

Broker service: kafka1 would run in node1
Broker service: kafka2 would run in node2

Node1 = Swarm Manager
Node2 = Swarm Worker
Node3 = client

node1 > sudo nano /etc/hosts
add
172.16.0.4      node2

[bp2024@node1 ~]$ ping node2
PING node2 (172.16.0.4) 56(84) bytes of data.
64 bytes from node2 (172.16.0.4): icmp_seq=1 ttl=64 time=0.709 ms
64 bytes from node2 (172.16.0.4): icmp_seq=2 ttl=64 time=0.708 ms

node2 > sudo nano /etc/hosts
add
172.16.0.3      node1

bp2024@node2 ~]$ ping node1
PING node1 (172.16.0.3) 56(84) bytes of data.
64 bytes from node1 (172.16.0.3): icmp_seq=1 ttl=64 time=0.805 ms
64 bytes from node1 (172.16.0.3): icmp_seq=2 ttl=64 time=0.826 ms

### Setup labels in nodes

```console
[bp2024@node1 ~]$ docker node update --label-add kafka=1 node1
node1
[bp2024@node1 ~]$ docker node update --label-add kafka=2 node2
node2
```

### Setup Kafka Cluster using docker swarm commands
First, we will attempt to setup kafka cluster using docker swarm commands, so that we can understand how do we compose them.

Step 1: Create a overlay network: kafka-net

```console
[bp2024@node1 ~]$ docker network create --driver overlay kafka-net
uujtx6dbama4lm925o92jhg2z
```

Step 2: Create broker : kafka1

```console
docker service create \
--name kafka1 \
--mount type=volume,source=k1-logs,destination=/tmp/kafka-logs \
--publish 9092:9092 \
--network kafka-net \
--mode global \
--constraint node.labels.kafka==1 \
frankv72/bp2024:1.0 \
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties \
--env KAFKA_NODE_ID: 1 \
--env KAFKA_CONTROLLER_LISTENER_NAMES: 'CONTROLLER' \
--env KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: 'CONTROLLER:PLAINTEXT,INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT' \
--env KAFKA_LISTENERS: 'INTERNAL://kafka1:29092,CONTROLLER://kafka1:29093,EXTERNAL://0.0.0.0:9092' \
--env KAFKA_ADVERTISED_LISTENERS: 'INTERNAL://kafka1:29092,EXTERNAL://localhost:9092' \
--env KAFKA_INTER_BROKER_LISTENER_NAME: 'INTERNAL' \
--env KAFKA_CONTROLLER_QUORUM_VOTERS: '1@kafka1:29093,2@kafka2:29093,3@kafka3:29093' \
--env KAFKA_PROCESS_ROLES: 'broker,controller' \
--env KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0 \
--env KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 3 \
--env KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 3 \
--env CLUSTER_ID: 'ciWo7IWazngRchmPES6q5A==' \
--env KAFKA_LOG_DIRS: '/tmp/kraft-combined-logs' 
```

This works
```console
docker service create \
    --name kafka1 \
    --mount type=volume,source=k1-logs,destination=/tmp/kafka-logs \
    --publish 9093:9093 \
    --network kafka-net \
    --mode global \
    --constraint node.labels.kafka==1 \
frankv72/bp2024:1.0 \
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties \
 --override listeners=INT://:9092,EXT://0.0.0.0:9093 \
 --override listener.security.protocol.map=INT:PLAINTEXT,EXT:PLAINTEXT \
 --override inter.broker.listener.name=INT \
 --override advertised.listeners=INT://:9092,EXT://node3:9093 \
 --override broker.id=1
```

Now go for second broker on node2


docker service create \
  --name kafka2 \
  --mount type=volume,source=k2-logs,destination=/tmp/kafka-logs \
  --publish 9094:9094 \
  --network kafka-net \
  --mode global \
  --constraint node.labels.kafka==2 \
frankv72/bp2024:1.0 \
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties \
 --override listeners=INT://:9092,EXT://0.0.0.0:9094 \
 --override listener.security.protocol.map=INT:PLAINTEXT,EXT:PLAINTEXT \
 --override inter.broker.listener.name=INT \
 --override advertised.listeners=INT://:9092,EXT://node4:9094 \
 --override broker.id=2


 #### test 

wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
sudo dnf install java-11-openjdk
tar xfz kafka_2.13-3.7.0.tgz 
mv kafka_2.13-3.7.0 kafka

bin/kafka-topics.sh  \
--bootstrap-server 172.16.0.3:9093 \
--create \
--replication-factor 1 \
--partitions 1 \
--topic test



```console
docker service create \
    --name kafka1 \
    --mount type=volume,source=k1-logs,destination=/tmp/kafka-logs \
    --publish 9093:9093 \
    --network kafka-net \
    --mode global \
    --constraint node.labels.kafka==1 \
frankv72/bp2024:1.1 \
KAFKA_HEAP_OPTS=-Xms1G -Xmx1G \
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties \
--override node.id=1 \
--override broker.id=1 \
--override num.network.threads=3 \
--override num.io.threads=8 \
--override process.roles=broker,controller  \
--override listeners=BROKER://172.16.0.3:9092,CONTROLLER://172.16.0.3:9093  \
--override advertised.listeners=BROKER://172.16.0.3:9092  \
--override listener.security.protocol.map=BROKER:SASL_PLAINTEXT,CONTROLLER:SASL_PLAINTEXT  \
--override controller.listener.names=CONTROLLER  \
--override controller.quorum.voters=1@172.16.0.3:9093  \
--override inter.broker.listener.name=BROKER  \
--override sasl.enabled.mechanisms=PLAIN  \
--override sasl.mechanism.controller.protocol=PLAIN  \
--override sasl.mechanism.inter.broker.protocol=PLAIN \
--override authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer  \
--override allow.everyone.if.no.acl.found=false  \
--override super.users=User:admin  \
--override delete.topic.enable=true  \
--override socket.send.buffer.bytes=1048576  \
--override socket.receive.buffer.bytes=1048576  \
--override socket.request.max.bytes=104857600 \
--override num.partitions=3  \
--override default.replication.factor=2  \
--override min.insync.replicas=2  \
--override log.retention.hours=168  \
--override log.segment.bytes=1073741824  \
--override log.retention.check.interval.ms=300000  \
--override auto.create.topics.enable=true  \
--override unclean.leader.election.enable=false  



azgB17mFT8if8tYAPn4y6Q
bash kafka/bin/kafka-storage.sh format -t azgB17mFT8if8tYAPn4y6Q -c kafka/config/kraft/server.properties

```


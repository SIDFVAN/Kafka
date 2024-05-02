# POC Hadoop

## Config en Deploy

lijst van nodes in Docker Swarm

```console
[bp2024@node1 ~]$ docker node ls
ID                            HOSTNAME   STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
b0vxtj6gwr42pxprruskc928d *   node1      Ready     Active         Leader           26.0.0
g33ibmcs0x2q2rkgaa0c62j36     node2      Ready     Active                          26.0.0
[bp2024@node1 ~]$
```

Info over node

```console
docker inspect node1
```

Toon labels nodes

```console
[bp2024@node1 ~]$ docker node ls -q | xargs docker node inspect \
  -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}'
b0vxtj6gwr42pxprruskc928d [node1]: map[kafka:1]
g33ibmcs0x2q2rkgaa0c62j36 [node2]: map[kafka:2]
[bp2024@node1 ~]$

```

lijst van services

```console
[bp2024@node1 ~]$ docker service ls
ID        NAME      MODE      REPLICAS   IMAGE     PORTS
[bp2024@node1 ~]$
```

remove labels

```console
[bp2024@node1 ~]$ docker node update --label-rm kafka node1
node1
[bp2024@node1 ~]$ docker node update --label-rm kafka node2
```

toevoegen Hadoop Nodes

```console
 docker node update --label-add hadoop=1 node1
 docker node update --label-add hadoop=2 node2
```

lijst nodes

```console
[bp2024@node1 ~]$ docker node ls -q | xargs docker node inspect   -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}'
b0vxtj6gwr42pxprruskc928d [node1]: map[hadoop:1]
g33ibmcs0x2q2rkgaa0c62j36 [node2]: map[hadoop:2]
```

Maak overlay netwerk hadoop-net op node1

```console
[bp2024@node1 ~]$ docker network create --driver overlay hadoop-net
lcr7ulmxxltjebdfgkm3qm44a
[bp2024@node1 ~]$
```

Lijst netwerken

```console
[bp2024@node1 ~]$ docker network ls
NETWORK ID     NAME                         DRIVER    SCOPE
3c618bf9faa1   bridge                       bridge    local
8172f69fd939   docker_gwbridge              bridge    local
lcr7ulmxxltj   hadoop-net                   overlay   swarm
1cf6fe114d69   host                         host      local
py0vluvvfb0g   ingress                      overlay   swarm
c109dd20bbc5   none                         null      local
39c15ae89ac2   pyspark-playground_default   bridge    local
```

Installeer stack op Node1

```console
docker stack deploy -c docker-compose-Hadoop.yml hadoop --detach=false
```

```console
bp2024@node1 Hadoop]$ docker stack deploy -c docker-compose-Hadoop.yml hadoop --detach=false
Ignoring unsupported options: restart

Creating network hadoop_hadoop-net
Creating service hadoop_namenode
Creating service hadoop_datanode1
Creating service hadoop_datanode2
Creating service hadoop_datanode3
Creating service hadoop_datanode4
overall progress: 0 out of 1 tasks
b0vxtj6gwr42: ready     [======================================>            ]

```

[bp2024@node1 Hadoop]$ docker service ls
ID             NAME               MODE      REPLICAS   IMAGE                                             PORTS
938l9s2s6kjb   hadoop_datanode1   global    1/1        bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
nk88kqf64iky   hadoop_datanode2   global    1/1        bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
p07j10f4oyoh   hadoop_datanode3   global    1/1        bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
eoo91dy22n7p   hadoop_datanode4   global    1/1        bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
ig2q3v8rbkao   hadoop_namenode    global    1/1        bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8   *:9000->9000/tcp, *:9870->9870/tcp
[bp2024@node1 Hadoop]$ docker stack ps hadoop
ID             NAME                                         IMAGE                                             NODE      DESIRED STATE   CURRENT STATE           ERROR     PORTS
q6ogkgksd3xn   hadoop_datanode1.b0vxtj6gwr42pxprruskc928d   bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8   node1     Running         Running 2 minutes ago
at6g22b8angr   hadoop_datanode2.b0vxtj6gwr42pxprruskc928d   bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8   node1     Running         Running 2 minutes ago
kx165pam6hvb   hadoop_datanode3.b0vxtj6gwr42pxprruskc928d   bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8   node1     Running         Running 2 minutes ago
jykfjfup37qg   hadoop_datanode4.b0vxtj6gwr42pxprruskc928d   bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8   node1     Running         Running 2 minutes ago
ikrzqav8z1my   hadoop_namenode.b0vxtj6gwr42pxprruskc928d    bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8   node1     Running         Running 2 minutes ago


## Testen van Hadoop

Zie OLOD









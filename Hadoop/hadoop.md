# POC Hadoop

### Commands

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

```
docker stack deploy -c docker-compose-Hadoop.yml hadoop --detach=false
```
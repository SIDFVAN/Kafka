# Kafka server

https://medium.com/@azsecured/install-kafka-cluster-kraft-with-sasl-plaintext-and-acl-configs-ae01a1e0040d





## Install Ansible on control node

<https://www.simplilearn.com/tutorials/ansible-tutorial/ansible-installation>

```console
sudo yum install epel-release
sudo yum install ansible

sudo useradd  bp2024

sudo passwd bp2024 
HoGent2024

ip a 
172.16.8.3

ssh-keygen
ssh-copy-id osboxes@172.16.0.4
sudo hostnamectl set-hostname control

login as bp2024
ssh-copy-id bp2024@172.16.0.4



```
test ssh connect to bp2024@172.16.0.4 with no password

## GIT

```console

sudo yum install git
git config --global user.name "Frank Vanhoorne"
git config --global user.email "frank.vanhoorne@student.hogent.be"
git config --global push.default simple
git config --global core.autocrlf input
git config --global pull.rebase true

add ssh key to github (public key)
git clone git@github.com:SIDFVAN/Kafka.git
[bp2024@control ~]$ ls
install-nginx.yaml  inventory.yaml  Kafka
[bp2024@control ~]$

```



## Install Kafka node

```console
root 
osboxes.org
sudo loadkeys be
localectl set-keymap be                     
sudo adduser osboxes
passwd  osboxes
usermod -aG wheel osboxes

nmcli connection show
nmcli connection up enp0s3
nmcli con mod enp0s3 autoconnect yes 
nmcli d connect enp0s8
nmcli con mod enp0s8 autoconnect yes 
sudo reboot now

ip a 
172.16.0.4
sudo hostnamectl set-hostname kafka
```

### Install Confluence

#### Download the Confluent Platform collection from Ansible Galaxy

```console
[bp2024@control ~]$ ansible-galaxy collection install confluent.platform
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/confluent-platform-7.6.0.tar.gz to /home/bp2024/.ansible/tmp/ansible-local-78708bapqo7le/tmp1ou1uyc9/confluent-platform-7.6.0-oed5qyp3
Installing 'confluent.platform:7.6.0' to '/home/bp2024/.ansible/collections/ansible_collections/confluent/platform'
confluent.platform:7.6.0 was installed successfully
[bp2024@control ~]$ 

```
[bp2024@control ansible]$ ansible-config init --disabled -t all > ansible.cfg

edit ansible.cfg

```ini
[defaults]
hash_behaviour=merge
```
### Install conduktor on KafkaNode1

first install docker


curl -L https://releases.conduktor.io/quick-start -o docker-compose.yml && docker compose up -d --wait && echo "Conduktor started on http://localhost:8080"


ssh bp2024@172.16.0.4





sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker # allready exists
sudo usermod -aG docker bp2024

docker exec -it kafka1 bash

# Kafka server node 2

https://medium.com/@azsecured/install-kafka-cluster-kraft-with-sasl-plaintext-and-acl-configs-ae01a1e0040d

ssh osboxes@172.16.0.5

sudo yum update
sudo dnf install java-11-openjdk
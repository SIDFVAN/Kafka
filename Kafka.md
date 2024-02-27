# Kafka server

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
sudo loadkeys be
localectl set-keymap
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


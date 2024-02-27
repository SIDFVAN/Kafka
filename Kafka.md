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
```

test ssh connect to osboxes@172.16.0.4


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


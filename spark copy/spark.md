

ssh -p  40215 vicuser@vichogent.be

sudo hostnamectl set-hostname node5
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker vicuser
docker swarm init --advertise-addr 10.11.0.107
sudo nano /etc/docker/deamon.json
{json}
{
   "log-driver": "json-file",
   "log-opts": {
       "max-size": "10m",
       "max-file": "3"
   }
}

 sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    sudo systemctl start docker
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo nano /etc/hosts

docker swarm init --advertise-addr 10.11.0.109

    docker node update --label-add spark=1 node5
    docker node update --label-add spark=2 node6



Git
jdk

sudo yum install -y git
git config --global user.name "Frank Vanhoorne"
git config --global user.email "frank.vanhoorne@student.hogent.be"
git config --global push.default simple
git config --global core.autocrlf input
git config --global pull.rebase true

add ssh key to github (public key)
git clone git@github.com:SIDFVAN/Kafka.git

docker network create --driver overlay spark-net
yn96brk87q6cx6xttwrxgbn7k

docker stack deploy -c docker-compose.yarn.yml Spark --detach=false




ssh -p  40216 vicuser@vichogent.be

sudo hostnamectl set-hostname node6
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker vicuser
docker swarm init --advertise-addr 10.11.0.107
sudo nano /etc/docker/deamon.json
{json}
{
   "log-driver": "json-file",
   "log-opts": {
       "max-size": "10m",
       "max-file": "3"
   }
}

 sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    sudo systemctl start docker
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo nano /etc/hosts   

docker swarm join --token SWMTKN-1-13atmgvfp3oveyp0pyjjzdk5ipttkowq54fi62urbs1jjotmew-0xpela4gkxblq4wy3hq1gs5pn 10.11.0.109:2377

nodes

    docker node update --label-add spark=1 node1
    docker node update --label-add spark=2 node2
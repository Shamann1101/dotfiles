#!/bin/bash

# Установка docker

sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    jq
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y install docker-ce
# Переносим директорию загруженных образов в /opt/docker
sudo service docker stop
if [ -d "/var/lib/docker" ]; then
  if [ ! -L "/var/lib/docker" ]; then
    sudo mv /var/lib/docker /opt/docker
  fi
  else
  sudo mkdir /opt/docker
fi
sudo ln -s /opt/docker /var/lib/docker
sudo service docker start
sudo docker run --rm hello-world
# Снимаем блокировку паролем
sudo groupadd docker
sudo usermod -aG docker $USER

VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod +x $DESTINATION
docker --version
docker-compose --version

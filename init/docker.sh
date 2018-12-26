#!/bin/bash

# Установка docker

sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo bash -c 'echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update
sudo apt-cache policy docker-engine
sudo apt-get -y install docker-engine
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
# Снимаем блокировку паролем
sudo groupadd docker
sudo usermod -aG docker $USER

sudo bash -c "curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose

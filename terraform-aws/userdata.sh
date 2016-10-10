#!/usr/bin/env bash
echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
wget -q -O- http://nginx.org/keys/nginx_signing.key | apt-key add -
apt-add-repository ppa:ansible/ansible -y
wget -qO- https://get.docker.com/ | sh
curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
apt-get install -y software-properties-common ansible

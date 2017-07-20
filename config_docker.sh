#!/bin/sh
echo install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.15.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo create docker config
sudo mkdir /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/docker.conf
echo '[Service]' | sudo tee /etc/systemd/system/docker.service.d/docker.conf > /dev/null
echo 'ExecStart=' | sudo tee --append /etc/systemd/system/docker.service.d/docker.conf > /dev/null
# Enable Docker Remote API, Insecure Registry, use devicemapper storage driver to set Basesize
echo 'ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --insecure-registry=localhost:5000 --storage-driver=devicemapper --storage-opt=dm.basesize=50G' | sudo tee --append /etc/systemd/system/docker.service.d/docker.conf > /dev/null
echo flush config changes
sudo systemctl daemon-reload

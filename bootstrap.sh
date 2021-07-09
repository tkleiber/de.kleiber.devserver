#!/bin/bash
### Install Docker Engine on Ubuntu ###
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# - Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
# - Add Docker’s official GPG key:
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# - Use the following command to set up the stable repository.
sudo echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# - Update the apt package index, and install the latest version of Docker Engine and containerd
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

### Install Jenkins Docker Container ###
# https://www.jenkins.io/doc/book/installing/docker/
sudo docker network create jenkins
sudo docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2
sudo docker run \
  --name jenkins-jcasc \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --env JENKINS_ADMIN_ID="${jenkins_user}" \
  --env JENKINS_ADMIN_PASSWORD="${jenkins_password}" \
  tkleiber/jenkins:jcasc


#!/bin/sh
echo Config Jenkins
sudo apt-get update
sudo apt-get -y install screen
sudo apt-get -y install wget
sudo apt-get -y install openjdk-8-jre
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get -y install jenkins
sudo apt-get -y install git
sudo sed -i -e 's/JAVA_ARGS="-Djava.awt.headless=true"/JAVA_ARGS="-Djava.awt.headless=true -Dmail.smtp.starttls.enable=true"/g' /etc/default/jenkins

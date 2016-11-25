sudo yum -y install java
sudo yum -y install screen
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins
sudo sed -i -e 's/JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true"/JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Dmail.smtp.starttls.enable=true"/g' /etc/sysconfig/jenkins
sudo service jenkins start
#sudo echo "# Start on mount" | sudo tee /etc/udev/rules.d/90-vagrant-mount.rules > /dev/null
#sudo echo "SUBSYSTEM==\"bdi\",ACTION==\"add\",RUN+=\"/usr/bin/screen -m -d bash -c 'sleep 5;/usr/sbin/service jenkins start'\"" | sudo tee --append /etc/udev/rules.d/90-vagrant-mount.rules > /dev/null
#sudo echo "# Stop on unmount" | sudo tee --append /etc/udev/rules.d/90-vagrant-mount.rules > /dev/null
#sudo echo "SUBSYSTEM==\"bdi\",ACTION==\"remove\",RUN+=\"/usr/bin/screen -m -d bash -c 'sleep 5;/usr/sbin/service jenkins stop'\"" | sudo tee --append /etc/udev/rules.d/90-vagrant-mount.rules > /dev/null
#sudo chmod 644 /etc/udev/rules.d/90-vagrant-mount.rules
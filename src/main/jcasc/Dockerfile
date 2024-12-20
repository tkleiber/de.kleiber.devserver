# TODO Refine to fixed jenkins version.
FROM jenkinsci/blueocean
MAINTAINER Torsten Kleiber (torsten.kleiber@web.de)
# ignore admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
# install listed plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
# change to default synced folder run this with
# cd /vagrant
# export DOCKER_BUILDKIT=1
# docker build --progress=plain --tag myjenkins .
# docker run -p 8070:8080 --rm --name myjenkins myjenkins:latest
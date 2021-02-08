#!/bin/bash
# https://docs.docker.com/compose/install/
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# https://github.com/praqma/jcasc-conf
cd /scmlocal/jcasc-conf
./jcasc.sh up
./jcasc.sh down
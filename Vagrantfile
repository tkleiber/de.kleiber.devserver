Vagrant.configure(2) do |config|

  # use an packer created ubuntu box with vagrant user preinstalled as
  # - OEL requires docker ee
  # - official https://app.vagrantup.com/ubuntu/boxes/ does not have vagrant user
  config.vm.box = "bento/ubuntu-20.10"

  # port forwarding for:
  # docker local registry
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  # jenkins
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Create a private network
  config.vm.network "private_network", type: "dhcp"

  # persistant storage for docker registry
  config.vm.synced_folder "C:\\shared\\virtual_storage\\docker_registry", "/var/lib/registry", create: true
  # persistant storage for jenkins
  config.vm.synced_folder "C:\\shared\\virtual_storage\\jenkins_home", "/var/jenkins_home", create: true
  # persistant storage for software
  config.vm.synced_folder "D:\\download", "/software", :mount_options => ["dmode=555","fmode=555"]
  # persistant storage for projects
  config.vm.synced_folder "C:\\shared\\scmlocal", "/scmlocal", create: true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Development Server"
    vb.customize ["modifyvm", :id, "--memory", "16384"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
  end

  config.vm.provision "docker" do |docker|
    # Jenkins container
    # https://www.jenkins.io/doc/book/installing/docker/
    # https://www.vagrantup.com/docs/providers/docker/networking
    # vagrant docker provider creates and assign network named vagrant_network silently, vagrant docker provisioner not
    # config.vm.provider "docker" does not work at least on windows home, so I use the provisioner
    # so I configure the network jenkins via docker.post_install_provision after the docker installation
    docker.post_install_provision "shell", inline:"docker network create jenkins"
    docker.run "jenkins-docker", image: "docker:dind", args: "--detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume /var/jenkins_home:/var/jenkins_home --publish 2376:2376"
    docker.run "jenkins-blueocean", image: "jenkinsci/blueocean", args: "--detach --network jenkins --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --publish 8080:8080 --publish 50000:50000 --volume /var/jenkins_home:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro"
    # docker private registry container for storing later built docker images
    docker.run "registry", image: "registry", daemonize: true, args: "--detach --publish 5000:5000 --volume /var/lib/registry:/var/lib/registry"
  end
end

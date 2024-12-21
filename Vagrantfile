Vagrant.configure(2) do |config|

  config.vbguest.auto_update = true
  # Usage: for provisioning set environment
  # set JENKINS_USER=<jenkins_user>
  # set JENKINS_PASSWORD=<jenkins_password>
  # vagrant up

  # use an packer created ubuntu box with vagrant user preinstalled as
  # - OEL requires docker ee
  # - official https://app.vagrantup.com/ubuntu/boxes/ does not have vagrant user
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.boot_timeout = 1500

  # port forwarding for:
  # jenkins
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # persistant storage for projects
  config.vm.synced_folder "C:\\shared\\scmlocal", "/scmlocal", create: true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "DevelopmentServer"
    vb.customize ["modifyvm", :id, "--memory", "16384"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
  end

  config.vm.provision "shell"  do |s|
    s.path = "bootstrap.sh"
    # s.inline = "echo $1 $2"
    s.args = [ENV['JENKINS_USER'], ENV['JENKINS_PASSWORD']]
  end
end

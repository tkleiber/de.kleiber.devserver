Vagrant.configure(2) do |config|

  # use an packer created ubuntu box with vagrant user preinstalled as
  # - OEL requires docker ee
  # - official https://app.vagrantup.com/ubuntu/boxes/ does not have vagrant user
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.boot_timeout = 1500

  # port forwarding for:
  # jenkins
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.name = "DevelopmentServer"
    vb.customize ["modifyvm", :id, "--memory", "16384"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
  end

  config.vm.provision "shell", path: "bootstrap.sh"
end

Vagrant.configure(2) do |config|

  # Use an ubuntu box with vagrant user preinstalled as
  # - OEL reqires docker ee
  # - official https://app.vagrantup.com/ubuntu/boxes/ does not have vagrant user
  config.vm.box = "mrlesmithjr/zesty64"

  # Port Forwardings for:
  # - Oracle Application Express (APEX)
  config.vm.network "forwarded_port", guest: 80, host: 80, host_ip: "127.0.0.1"
  # - Oracle database port
  config.vm.network "forwarded_port", guest: 1521, host: 1521, host_ip: "127.0.0.1"
  # - Docker Local Registry
  config.vm.network "forwarded_port", guest: 5000, host: 5000, host_ip: "127.0.0.1"
  # - Oracle Enterprise Manager Express
  config.vm.network "forwarded_port", guest: 5500, host: 5500, host_ip: "127.0.0.1"
  # - Jenkins
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"

  # Create a private network
  config.vm.network "private_network", type: "dhcp"

  # persistant storage for docker registry
  config.vm.synced_folder "C:\\shared\\virtual_storage\\docker_registry", "/var/lib/registry", type: "nfs", owner: 994, group: 992, create: true
  # persistant storage for jenkins
  config.vm.synced_folder "C:\\shared\\virtual_storage\\jenkins_home", "/var/lib/jenkins", type: "nfs", owner: 994, group: 992, create: true
  # persistant storage for oracle
  config.vm.synced_folder "C:\\shared\\virtual_storage\\oracle", "/var/lib/oracle", type: "nfs", owner: 1000, group: 1000, create: true
  # persistant storage for software
  config.vm.synced_folder "D:\\download", "/software", :mount_options => ["dmode=555","fmode=555"]
  # persistant storage for software
  config.vm.synced_folder "C:\\shared\\scmlocal", "/scmlocal", type: "nfs", owner: 994, group: 992, create: true

  # virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    # name in VirtualBox
    vb.name = "Development Server"

    # configure 16 GB memory
    vb.customize ["modifyvm", :id, "--memory", "16384"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]

    # create addtional big dynamic vdi disk for docker images
=begin
    if !File.exist?("#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}_docker.vdi")
      # configure the SATA controller for 3 disk ports, for other box you may have another controller
      vb.customize [
        "storagectl", :id,
        "--name", "SATA Controller",
        "--controller", "IntelAHCI",
        "--portcount", "2"
      ]
      # create addtional big dynamic vdi (200 GB)
      vb.customize [
        "createhd",
        "--filename", "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}_docker.vdi",
        "--format", "VDI",
        "--size", 200 * 1024
      ]

      # attach the addtional disk to the controller
      vb.customize [
        "storageattach", :id,
        "--storagectl", "SATA Controller",
        "--port", "2",
        "--device", 0,
        "--type", "hdd",
        "--medium", "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}_docker.vdi"
      ]
    end
=end
  end
  # shell provider
  # format the additional disk and add the free space to the box
  # config.vm.provision :shell, :path => "add_disk.sh"
  # add swapfile to the box
  config.vm.provision :shell, :path => "add_swap.sh"
  # configure docker
  # config.vm.provision :shell, :path => "config_docker.sh"
  # add X11 libraries
  # config.vm.provision :shell, :path => "add_x11_libs.sh"
  # install jenkins
  config.vm.provision :shell, :path => "add_jenkins.sh"

  # Docker Private Registry container for storing later builded docker images, which are not in the Docker Public Registry at https://hub.docker.com/
  config.vm.provision "docker" do |d|
    d.run "registry", image: "registry", daemonize: true, args: "-d -p 5000:5000 -v /var/lib/registry:/var/lib/registry"
  end

  # restart jenkins and docker registry at each "vagrant up" to solve the problem, that virtualbox shared folders are mounted after start of services
  config.vm.provision :shell, :inline => "sudo service jenkins restart; docker stop registry; docker start registry", :run => "always"

end

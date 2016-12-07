Vagrant.configure(2) do |config|

  # Use the mentioned ready OEL 7 linux box
  config.vm.box = "oraclelinux-7-x86_64.box"
  config.vm.box_url = "http://cloud.terry.im/vagrant/oraclelinux-7-x86_64.box"

  # Port Forwardings for:
  # - Oracle Application Express (APEX)
  # config.vm.network "forwarded_port", guest: 80, host: 80
  # - Oracle database port
  config.vm.network "forwarded_port", guest: 1521, host: 1521
  # - Docker Local Registry
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  # - Oracle Enterprise Manager Express
  config.vm.network "forwarded_port", guest: 5500, host: 5500
  # - Jenkins
  config.vm.network "forwarded_port", guest: 8080, host: 80

  # Create a private network
  config.vm.network "private_network", type: "dhcp"

  # persistant storage for all docker container
  config.vm.synced_folder "C:\\shared\\virtual_storage", "/virtual_storage", :mount_options => ["dmode=777","fmode=777"]
  # persistant storage for jenkins
  config.vm.synced_folder "C:\\shared\\virtual_storage\\jenkins_home", "/var/lib/jenkins", type: "nfs", owner: 994, group: 992, create: true
  # persistant storage for software
  config.vm.synced_folder "D:\\download", "/software", :mount_options => ["dmode=555","fmode=555"]
  
  # virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    # name in VirtualBox
    vb.name = "Development Server"

    # configure 16 GB memory 
    vb.customize ["modifyvm", :id, "--memory", "16384"]

    # clone the original vmdk disk into a dynamic vdi disk, which only allocate the used space on the host
    if ARGV[0] == "up" && ! File.exist?("#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}.vdi")
      # configure the SATA controller for second disk port, for other box you may have another controller
      vb.customize [
        "storagectl", :id, 
        "--name", "SATA", 
        "--controller", "IntelAHCI", 
        "--portcount", "1", 
        "--hostiocache", "on"
      ]
      # clone the original disk, for other box you may have another disk name
      vb.customize [
        "clonehd", "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/box-disk2.vmdk", 
             "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}.vdi", 
        "--format", "VDI"
      ]
      # attach the cloned disk to the controller
      vb.customize [
        "storageattach", :id, 
        "--storagectl", "SATA", 
        "--port", "0", 
        "--device", "0", 
        "--type", "hdd",
        "--nonrotational", "on",
        "--medium", "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}.vdi" 
      ]
      # delete the original disk to release it's space
      vb.customize [
        "closemedium", "disk", "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/box-disk2.vmdk", 
        "--delete"
      ]
    end

    # create addtional big dynamic vdi disk for docker images
    if !File.exist?("#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}_docker.vdi")
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
        "--storagectl", "SATA", 
        "--port", "1", 
        "--device", 0, 
        "--type", "hdd",
        "--medium", "#{ENV["HOME"]}/VirtualBox VMs/#{vb.name}/#{vb.name}_docker.vdi"
      ]
    end
  end

  # shell provider
  # format the additional disk and add the free space to the box
  config.vm.provision :shell, :path => "add_disk.sh"
  # add swapfile to the box
  config.vm.provision :shell, :path => "add_swap.sh"
  # configure docker 
  config.vm.provision :shell, :path => "config_docker.sh"
  # install jenkins 
  config.vm.provision :shell, :path => "add_jenkins.sh"
  # restart jenkins at each "vagrant up" to solve the problem, that virtualbox shared folders are mounted after start of services
  config.vm.provision :shell, :inline => "sudo service jenkins restart", :run => "always"

  # Docker Private Registry container for storing later builded docker images, which are not in the Docker Public Registry at https://hub.docker.com/
  config.vm.provision "docker" do |d|
    d.run "registry", image: "registry", daemonize: true, args: "-d -p 5000:5000 -v /virtual_storage/docker_registry:/var/lib/registry"
  end

  # Jenkins LTS
  # config.vm.provision "docker" do |d|
  #   d.run "jenkins", image: "jenkins", daemonize: true, args: "-d -p 80:8080 -p 50000:50000 -v /virtual_storage/jenkins_home:/var/jenkins_home"
  # end
end
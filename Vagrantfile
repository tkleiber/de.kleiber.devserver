Vagrant.configure(2) do |config|

  # Use the mentioned ready OEL 7 linux box
  config.vm.box = "oraclelinux-7-x86_64.box"
  config.vm.box_url = "http://cloud.terry.im/vagrant/oraclelinux-7-x86_64.box"

  # Create a private network
  config.vm.network "private_network", type: "dhcp"

  # persistant storage for all docker container
  config.vm.synced_folder "C:\\shared\\virtual_storage", "/virtual_storage", :mount_options => ["dmode=777","fmode=777"]
  
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

  # Docker Private Registry container for storing later builded docker images, which are not in the Docker Public Registry at https://hub.docker.com/
  config.vm.provision "docker" do |d|
    d.run "registry", image: "registry", daemonize: true, args: "-d -p 5000:5000 -v /virtual_storage/docker_registry:/var/lib/registry"
  end

end
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
	end

  # Docker Private Registry container for storing later builded docker images, which are not in the Docker Public Registry at https://hub.docker.com/
  config.vm.provision "docker" do |d|
    d.run "registry", image: "registry", daemonize: true, args: "-d -p 5000:5000 -v /virtual_storage/docker_registry:/var/lib/registry"
  end

end
# ISSD CAT2 LAB - TWO REPRODUCIBLE LINUX ENDPOINTS
# Windows 11 is the third endpoint and is installed separately from the official Microsoft ISO.
# Tested syntax only. The actual boxes and machines must be verified on your laptops.
Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  systems = {
    "ubuntu" => { box: "bento/ubuntu-24.04", ip: "192.168.56.11", ram: 2048, role: "ubuntu" },
    "debian" => { box: "bento/debian-12", ip: "192.168.56.12", ram: 1536, role: "debian" }
  }

  systems.each do |name, os|
    config.vm.define name do |vm|
      vm.vm.box = os[:box]
      vm.vm.box_architecture = "amd64"
      vm.vm.hostname = "issd-#{name}"
      vm.vm.network "private_network", ip: os[:ip]
      vm.vm.boot_timeout = 600
      vm.vm.provider "virtualbox" do |vb|
        vb.name = "ISSD-CAT2-#{name}"
        vb.memory = os[:ram]
        vb.cpus = 1
        vb.gui = false
      end
      vm.vm.provision "shell", path: "scripts/bootstrap-linux.sh", args: [os[:role]]
    end
  end
end

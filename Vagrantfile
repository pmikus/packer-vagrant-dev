# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Variables.
    vagrant_box_path = "box"

    # Configure cached packages to be shared between instances of the same
    # base box.
    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
    end

    # Configure proxy if needed.
    if Vagrant.has_plugin?("vagrant-proxyconf")
        config.proxy.http     = "http://192.168.0.2:3128/"
        config.proxy.https    = "http://192.168.0.2:3128/"
        config.proxy.ftp      = "http://192.168.0.2:3128/"
        config.proxy.no_proxy = "localhost,127.0.0.1"
    end

    # This is an optional plugin that, if installed, updates the host's
    # /etc/hosts file with the hostname of the guest VM. In Fedora it is
    # packaged as ``vagrant-hostmanager``.
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
    end

    # Whether to check the correct additions version only. This will warn you
    # about version mis-matches, but will not try to install anything.
    config.vbguest.no_install = false
    # Set auto_update to false, if you do NOT want to check the correct
    # additions version when booting this machine.
    config.vbguest.auto_update = true
    # Do NOT download the iso file from a webserver.
    config.vbguest.no_remote = true
    # Whether to reboot the box after GuestAdditions has been installed, but not
    # loaded.
    config.vbguest.auto_reboot = true

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    config.vm.synced_folder ".", "/vagrant", disabled: false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    config.vm.network "forwarded_port", id: "web", guest: 80, host_ip: "127.0.0.1", host: 8081, protocol: "tcp"
    config.vm.network "forwarded_port", id: "ssh", guest: 22, host_ip: "127.0.0.1", host: 8022, protocol: "tcp"

    # Configure testing network interfaces.
    config.vm.network :private_network, auto_config: false, virtualbox__intnet: "link1", nic_type: "82545EM", mac: "080027000001"
    config.vm.network :private_network, auto_config: false, virtualbox__intnet: "link2", nic_type: "82545EM", mac: "080027000002"
    config.vm.network :private_network, auto_config: false, virtualbox__intnet: "link1", nic_type: "82545EM", mac: "080027000003"
    config.vm.network :private_network, auto_config: false, virtualbox__intnet: "link2", nic_type: "82545EM", mac: "080027000004"

    # Enable provisioning with a ansible. Additional provisioners such as
    # Puppet, Chef, Shell, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    config.vm.provision "ansible_local" do |ansible|
        ansible.install = false
        ansible.version = "latest"
        ansible.compatibility_mode = "2.0"
        ansible.become = true
        ansible.verbose = false
        ansible.limit = "all"
        ansible.inventory_path = "ansible/inventory"
        ansible.playbook = "ansible/master.yml"
    end

    config.vm.define "ubuntu_impish_server" do |flavor|
        # Base box definition, currently using.
        #  Packer Ubuntu 21.10 VirtualBox image.
        flavor.vm.box = "#{vagrant_box_path}/packer-ubuntu-server-21.10-virtualbox.box"
        #flavor.vm.box_version = "0.1"
        flavor.vm.box_check_update = true

        # Virtualbox machine configuration.
        flavor.vm.provider "virtualbox" do |vb|
            vb.name = "vagrant_ubuntu_impish_server"
            vb.gui = true
            vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
            vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
            vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
            vb.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
            vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
            vb.customize ["modifyvm", :id, "--memory", 8192]
            vb.customize ["modifyvm", :id, "--cpus", 4]
            vb.customize ["modifyvm", :id, "--vram", 256]
            vb.customize ["modifyvm", :id, "--ioapic", "on"]
            vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
            vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
            vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
            vb.customize ["modifyvm", :id, "--usb", "on"]
        end
    end
end

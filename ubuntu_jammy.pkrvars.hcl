boot_wait         = "10s"
cpus              = 4
disk_size         = 65536
firmware          = "bios"
gfx_controller    = "vboxsvga"
gfx_vram_size     = 128
gfx_accelerate_3d = true
guest_os_family   = "linux"
guest_os_member   = "server"
guest_os_type     = "ubuntu_64"
guest_os_vendor   = "ubuntu"
guest_os_version  = "22.04"
iso_url           = "https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
iso_checksum      = "sha256:84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
memory            = 2048
nic_type          = "82540EM"
shell_scripts     = [
    "scripts/vagrant.sh",
    "scripts/setup.sh"
]
ssh_password      = "vagrant"
ssh_username      = "vagrant"
template          = "base_ubuntu_amd64.pkr.hcl"

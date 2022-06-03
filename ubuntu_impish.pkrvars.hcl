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
guest_os_version  = "21.10"
iso_url           = "https://releases.ubuntu.com/21.10/ubuntu-21.10-live-server-amd64.iso"
iso_checksum      = "sha256:e84f546dfc6743f24e8b1e15db9cc2d2c698ec57d9adfb852971772d1ce692d4"
memory            = 2048
nic_type          = "82540EM"
shell_scripts     = [
    "scripts/vagrant.sh",
    "scripts/setup.sh"
]
ssh_password      = "vagrant"
ssh_username      = "vagrant"
template          = "builder.pkr.hcl"

locals {
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  name      = "${var.guest_os_vendor}-${var.guest_os_member}-${var.guest_os_version}"
}

variable "audio_controller" {
  type        = string
  description = "The audio controller type to be used."
  default     = "ac97"
}

variable "boot_wait" {
  type        = string
  description = "The time to wait after booting the initial virtual machine before typing the boot_command."
  default     = "10s"
}

variable "cpus" {
  type        = number
  description = "The number of virtual CPUs cores per socket."
  default     = 1
}

variable "disk_size" {
  type        = number
  description = "The size for the virtual disk in MB."
  default     = 10000
}

variable "firmware" {
  type        = string
  description = "The firmware to be used: BIOS or EFI."
  default     = "bios"
}

variable "gfx_controller" {
  type        = string
  description = "The graphics controller type to be used."
  default     = "vboxsvga"
}

variable "gfx_vram_size" {
  type        = number
  description = "The VRAM size to be used."
  default     = 4
}

variable "gfx_accelerate_3d" {
  type        = bool
  description = "3D acceleration: true or false."
  default     = false
}

variable "guest_os_family" {
  type        = string
  description = "The guest operating system family."
  default     = ""
}

variable "guest_os_member" {
  type        = string
  description = "The guest operating system member."
  default     = ""
}

variable "guest_os_type" {
  type        = string
  description = "The guest OS type being installed."
  default     = ""
}

variable "guest_os_vendor" {
  type        = string
  description = "The guest operating system vendor."
  default     = ""
}

variable "guest_os_version" {
  type        = string
  description = "The guest operating system version."
  default     = ""
}

variable "hard_drive_interface" {
  type        = string
  description = "The type of controller that the primary hard drive is attached to, defaults to ide."
  default     = "sata"
}

variable "headless" {
  type        = bool
  description = "Packer defaults to building VirtualBox virtual machines by launching a GUI."
  default     = false
}

variable "http_directory" {
  type        = string
  description = "Path to a directory to serve using an HTTP server."
  default     = "http"
}

variable "iso_url" {
  type        = string
  description = "A URL to the ISO containing the installation image or virtual hard drive (VHD or VHDX) file to clone."
  default     = "https://releases.ubuntu.com/21.10/ubuntu-21.10-live-server-amd64.iso"
}

variable "iso_checksum" {
  type        = string
  description = "The checksum for the ISO file or virtual hard drive file."
  default     = "sha256:e84f546dfc6743f24e8b1e15db9cc2d2c698ec57d9adfb852971772d1ce692d4"
}

variable "memory" {
  type        = number
  description = "The amount of memory to use for building the VM in megabytes."
  default     = 1024
}

variable "nested_virt" {
  type        = bool
  description = "Nested virtualization: false or true."
  default     = true
}

variable "nic_type" {
  type        = string
  description = "The NIC type to be used for the network interfaces."
  default     = "82540EM"
}

variable "shutdown_timeout" {
  type        = string
  description = "The amount of time to wait after executing the shutdown_command for the virtual machine to actually shut down."
  default     = "15m"
}

variable "ssh_password" {
  type        = string
  description = "The plaintext password to use to authenticate over SSH."
  default     = ""
  sensitive   = true
}

variable "ssh_username" {
  type        = string
  description = "The username to use to authenticate over SSH."
  default     = "root"
  sensitive   = true
}

variable "ssh_timeout" {
  type        = string
  description = "The time to wait for SSH to become available."
  default     = "1h"
}

variable "shell_scripts" {
  type        = list(string)
  description = "A list of scripts."
  default     = [
    "scripts/setup.sh"
  ]
}

variable "template" {
  type        = string
  description = "Template name."
  default     = ""
}

source "virtualbox-iso" "base-ubuntu-amd64" {
  audio_controller = var.audio_controller
  boot_command        = [
    "c",
    "linux /casper/vmlinuz ",
    "\"ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" ",
    "autoinstall ---",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot<enter>"
  ]
  boot_wait            = var.boot_wait
  cpus                 = var.cpus
  disk_size            = var.disk_size
  firmware             = var.firmware
  guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
  gfx_controller       = var.gfx_controller
  gfx_vram_size        = var.gfx_vram_size
  gfx_accelerate_3d    = var.gfx_accelerate_3d
  guest_os_type        = var.guest_os_type
  hard_drive_interface = var.hard_drive_interface
  headless             = var.headless
  http_directory       = var.http_directory
  iso_url              = var.iso_url
  iso_checksum         = var.iso_checksum
  memory               = var.memory
  nested_virt          = var.nested_virt
  nic_type             = var.nic_type
  output_directory     = "box/packer-${local.name}-virtualbox"
  shutdown_command     = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  shutdown_timeout     = var.shutdown_timeout
  ssh_password         = var.ssh_password
  ssh_port             = 22
  ssh_username         = var.ssh_username
  ssh_timeout          = var.ssh_timeout
  vm_name              = "${local.name}"
}

build {
  name        = "ubuntu"
#  description = <<EOF
#This build creates images for :
#* ${local.name}
#For the following builders :
#* virtualbox-iso
#EOF
  sources = [
    "source.virtualbox-iso.base-ubuntu-amd64"
  ]
  post-processor "vagrant" {
    keep_input_artifact = true
    provider_override   = "virtualbox"
  }
  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=/home/${var.ssh_username}",
      "BUILD_USERNAME=${var.ssh_username}",
    ]
    execute_command   = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    expect_disconnect = true
    scripts           = var.shell_scripts
  }
}

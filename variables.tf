variable "libvirt_pool_name" {
  type        = string
  description = "Name of our lab's libvirt storage pool. Avoid using the name `default`. Example: `mytestpool`."
}

variable "libvirt_pool_dir" {
  type        = string
  description = "Directory on your local storage where the pool directory should be located. This directory might have to be created manually with the correct permissions so qemu or libvirt can access it."
}
variable "cloud_image" {
  type        = string
  description = "Full path to the image of your VM's operating system. Only 'cloud' variety of various images are supported like Fedora-Cloud or Ubuntu-Cloud. Example `/home/myusername/Downloads/Fedora-Cloud-Base-39-1.5.x86_64.qcow2`"
}

variable "libvirt_network_name" {
  type        = string
  description = "Name of our libvirt network. Example `mytestnetwork`"
}

variable "bridge_device" {
  type        = string
  description = "Name of the network bridge device. For example `br0`"
  default     = "br0"
}

variable "lab_vms" {
  type = list(object({
    quantity = number
    name     = string
    ram      = number # In Megabytes
    vcpu     = number
    meta_data = object({ # https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html#example-meta-data
      instance-id : string
      local-hostname : string
    })
    user_data = any # Follow the structure as seen in examples here: https://cloudinit.readthedocs.io/en/latest/reference/modules.html
    # Follow the network-config format v2 (v1 untested): https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html
    # However, keep in mind the bug: https://askubuntu.com/questions/1405294/ubuntu-20-04-cloud-init-wont-configure-network
    network_configs = any # list(any) doesn't work if we concatenate lists, so to allow more freedom, I opted for any
  }))
  description = "List of objects that represent your VMs. `meta_data`, `user_data` and `network_configs` are exposed as non-guardrailed maps so the user has full customizability."
}

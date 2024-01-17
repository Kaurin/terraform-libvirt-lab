variable "libvirt_pool_name" {
  type        = string
  description = "Name of our lab's libvirt storage pool. Avoid using the name `default`. Example: `mytestpool`."
}

variable "libvirt_pool_dir" {
  type        = string
  description = "Directory on your local storage where the pool directory should be located. This directory might have to be created manually with the correct permissions so qemu or libvirt can access it."
  # Fedora: sudo mkdir /var/CHANGE_THIS_NAME && sudo chown qemu:qemu /var/CHANGE_THIS_NAME
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
    user_data      = any      # Follow the structure as seen in examples here: https://cloudinit.readthedocs.io/en/latest/reference/modules.html
    network_config = map(any) # Follow the network-config format v2 (v1 untested): https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html
  }))
  description = "List of objects that represent your VMs. `meta_data`, `user_data` and `network_config` are exposed as non-guardrailed maps so the user has full customizability."
}

variable "libvirt_pool_dir" {
  type    = string
  default = "/var/lab_cluster_libvirt_volume_pool"
}
variable "cloud_image" {
  type = string
}
variable "cloud_image_pool" {
  type    = string
  default = "default"
}

variable "lab_vms" {
  type = list(object({
    name           = string
    ram            = number # In Megabytes
    vcpu           = number
    meta_data      = map(any) # Follow the structure as seen here: https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html#example-meta-data
    user_data      = map(any) # Follow the structure as seen in examples here: https://cloudinit.readthedocs.io/en/latest/reference/modules.html
    network_config = map(any) # Follow the network-config format v2 (v1 untested): https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html
  }))
}

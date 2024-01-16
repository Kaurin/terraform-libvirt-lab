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

variable "ssh_user" {
  type    = string
  default = "lab"
}

variable "ssh_authorized_key" {
  type = string
}

variable "lab_vms" {
  type = list(object({
    name        = string
    ram         = number # In Megabytes
    vcpu        = number
    ipaddrs     = list(string)
    dnsaddrs    = list(string)
    net_gateway = string
    eth_devname = string
  }))
  default = [
    {
      name        = "example_box"
      ram         = 2048
      vcpu        = 4
      ipaddrs     = ["192.168.0.150"]
      dnsaddrs    = ["1.1.1.1"]
      net_gateway = "192.168.0.1"
      eth_devname = "eth0"
    }
  ]
}

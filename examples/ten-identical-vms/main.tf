
# Notice when we are creating multiples of a machine (quantity > 1) that we are setting DHCP under network_config.
# It would currently *maybe* be possible to write some increment logic for the IPs but would be considered very anti-pattern for terraform.
# If there is a need for static IPs for multiples of machines, we recommend either setting up your DHCP rules and custom MAC addresses
# Or in some othe way, perhaps through using userdata and an external source of truth


module "ten_identical_vms" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "ten_identical_vms_pool"
  libvirt_pool_dir  = "/var/libvirt_ten_identical_vms_dir"
  cloud_image       = "/var/lib/libvirt/images/Fedora-Cloud-Base-39-1.5.x86_64.qcow2"

  libvirt_network_name = "ten_identical_vms_network"
  bridge_device        = "br0"

  lab_vms = [
    {
      name     = "clonebox"
      quantity = 10
      ram      = 512
      vcpu     = 1
      meta_data = {
        "instance-id" : "clonebox",
        "local-hostname" : "clonebox"
      }
      user_data = {
        "users" : [
          {
            "name" : "myuser"
            "ssh_authorized_keys" : [
              "ssh-rsa YOUR_LONG_PUBKEY_HERE key's_comment"
            ]
            "sudo" : "ALL=(ALL) NOPASSWD:ALL"
            "lock_passwd" : true
            "groups" : "sudo"
            "shell" : "/bin/bash"
          }
        ]
      }
      network_config = {
        "network" : {
          "version" : 2
          "ethernets" : {
            "eth0" : {
              "dhcp4" : true
            }
          }
        }
      }
    }
  ]
}

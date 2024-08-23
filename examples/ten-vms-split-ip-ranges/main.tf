# Some of these VMs use static IPs and others use DHCP
module "split_ip_ranges" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "split_ip_ranges_vms_pool"
  libvirt_pool_dir  = "/var/libvirt_split_ip_ranges_vms_dir"
  cloud_image       = "/home/myuser/Downloads/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"

  libvirt_network_name = "split_ip_ranges_vms_network"
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
      # If using "range" for "network_configs", the total must match the "quantity" above.
      # We are concatinating two lists of network_configs into a single list. 
      # Each of the list has a different set of sequential IPs, hence the need for two lists
      network_configs = concat(
        [
          for num in range(161, 166) : # 5 values, goes up to 165
          {
            "version" : 2
            "ethernets" : {
              "eth0" : {
                "addresses" : ["192.168.0.${num}/24"]
                "gateway4" : "192.168.0.1"
                "nameservers" : {
                  "addresses" : ["192.168.0.1", "192.168.0.2"]
                }
              }
            }
          }
        ],
        [
          for num in range(201, 206) : # 5 values, goes up to 205
          {
            "version" : 2
            "ethernets" : {
              "eth0" : {
                "addresses" : ["192.168.0.${num}/24"]
                "gateway4" : "192.168.0.1"
                "nameservers" : {
                  "addresses" : ["192.168.0.1", "192.168.0.2"]
                }
              }
            }
          }
        ]
      )
    }
  ]
}

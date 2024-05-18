# Some of these VMs use static IPs and others use DHCP
module "single_ip_range" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "single_ip_rangevms_pool"
  libvirt_pool_dir  = "/var/libvirt_single_ip_rangevms_dir"
  cloud_image       = "/home/myuser/Downloads/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"

  libvirt_network_name = "single_ip_rangevms_network"
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
      network_configs = [
        for num in range(161, 171) : # 10 values, goes up to 170
        {
          "network" : {
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
        }
      ]
    }
  ]
}

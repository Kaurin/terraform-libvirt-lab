# Some of these VMs use static IPs and others use DHCP
module "single_ip_range" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "single_ip_rangevms_pool"
  libvirt_pool_dir  = "/var/libvirt-pools/libvirt_single_ip_rangevms_dir"
  cloud_image       = "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-44-1.7.x86_64.qcow2" # or  "/home/myuser/Downloads/images/Fedora-Cloud-Base-Generic-44-1.7.x86_64.qcow2"

  capacity             = 10737418240 # 10 GiB
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
              "ssh-rsa YOUR_SSH_PUBKEY pubkey_comment"
            ]
            "sudo" : "ALL=(ALL) NOPASSWD:ALL"
            "lock_passwd" : false # Set to `true` if not using passwords
            "groups" : "sudo"
            "shell" : "/bin/bash"
            "plain_text_passwd" : "test123" ## Don't use plaintext passwords if you can avoid them
          }
        ]
      }
      # If using "range" for "network_configs", the total must match the "quantity" above.
      network_configs = [
        for num in range(161, 171) : # 10 values, goes up to 170
        {
          "version" : 2
          "ethernets" : {
            "enp1s0" : {
              "addresses" : ["192.168.0.${num}/24"]
              "gateway4" : "192.168.0.1"
              "nameservers" : {
                "addresses" : ["192.168.0.1", "192.168.0.2"]
              }
            }
          }
        }
      ]
    }
  ]
}

module "two_different_vms" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "two_different_vms_pool"
  libvirt_pool_dir  = "/var/libvirt-pools/libvirt_two_different_vms_dir"
  cloud_image       = "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-44-1.7.x86_64.qcow2" # or  "/home/myuser/Downloads/images/Fedora-Cloud-Base-Generic-44-1.7.x86_64.qcow2"

  capacity             = 10737418240 # 10 GiB
  libvirt_network_name = "two_different_vms_network"
  bridge_device        = "br0"

  lab_vms = [
    {
      name     = "mainbox"
      quantity = 1
      ram      = 512
      vcpu     = 1
      meta_data = {
        "instance-id" : "mainbox",
        "local-hostname" : "mainbox"
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
            "plain_text_passwd" : "test123" ## Don't use plaintext passwords if you can avoid them
          }
        ]
      }
      network_configs = [
        {
          "version" : 2
          "ethernets" : {
            "enp1s0" : {
              "addresses" : ["192.168.0.150/24"]
              "gateway4" : "192.168.0.1"
              "nameservers" : {
                "addresses" : ["1.1.1.1"]
              }
            }
          }
        }
      ]
    },
    {
      name     = "agentbox"
      quantity = 1
      ram      = 1024
      vcpu     = 2
      meta_data = {
        "instance-id" : "agentbox",
        "local-hostname" : "agentbox"
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
      network_configs = [
        {
          "version" : 2
          "ethernets" : {
            "enp1s0" : {
              "addresses" : ["192.168.0.151/24"]
              "gateway4" : "192.168.0.1"
              "nameservers" : {
                "addresses" : ["8.8.8.8"]
              }
            }
          }
        }
      ]
    }
  ]
}

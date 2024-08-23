
module "single_ubuntu" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "ubuntu_pool"
  libvirt_pool_dir  = "/var/ubuntu_pool"
  cloud_image       = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"

  libvirt_network_name = "ubuntu_network"
  bridge_device        = "br0"

  lab_vms = [
    {
      name     = "ubuntu"
      quantity = 1
      ram      = 1024
      vcpu     = 2
      meta_data = {
        "instance-id" : "ubuntu",
        "local-hostname" : "ubuntu"
      }
      user_data = {
        "users" : [
          {
            "name" : "myuser"
            "ssh_authorized_keys" : [
              "ssh-rsa YOUR_SSH_PUBKEY pubkey_comment"
            ]
            "sudo" : "ALL=(ALL) NOPASSWD:ALL"
            "lock_passwd" : false
            "groups" : "sudo"
            "shell" : "/bin/bash"
            "plain_text_passwd" : "test123" ## Never do this!
          }
        ]
      }
      network_configs = [
        {
          "version" : 2
          "ethernets" : {
            "ens3" : {
              "addresses" : ["192.168.0.160/24"]
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

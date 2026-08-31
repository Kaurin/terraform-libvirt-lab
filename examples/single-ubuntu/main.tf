
module "single_ubuntu" {
  # source = "git::git@github.com:Kaurin/terraform-libvirt-lab.git"
  source = "../.."

  libvirt_pool_name = "ubuntu_pool"
  libvirt_pool_dir  = "/var/libvirt-pools/ubuntu_pool"
  cloud_image       = "https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img" # or  "/home/myuser/Downloads/images/resolute-server-cloudimg-amd64.img

  capacity             = 10737418240 # 10 GiB
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
            "lock_passwd" : false ## Set to `true` if not using passwords
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

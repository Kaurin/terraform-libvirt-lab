locals {
  loop_vms = {
    for index, vm in var.lab_vms :
    vm.name => vm
  }
}

resource "libvirt_pool" "lab_cluster" {
  name = "lab_cluster"
  type = "dir"
  path = var.libvirt_pool_dir
}

resource "libvirt_network" "lab_network" {
  name   = "lab_network"
  mode   = "bridge"
  bridge = "br0"
}

resource "libvirt_volume" "cloud_image" {
  name   = "cloud_image.qcow2"
  pool   = var.cloud_image_pool
  source = var.cloud_image
  format = "qcow2"
}

resource "libvirt_volume" "lab_volume" {
  for_each         = local.loop_vms
  name             = "${each.value.name}.qcow2"
  pool             = libvirt_pool.lab_cluster.name
  base_volume_id   = libvirt_volume.cloud_image.id
  base_volume_pool = libvirt_pool.lab_cluster.name
  format           = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  for_each = local.loop_vms

  name = "${each.value.name}.iso"

  meta_data = yamlencode({
    "instance-id" : each.value.name,
    "local-hostname" : each.value.name
  })

  user_data = join("\n", ["#cloud-config",
    yamlencode({
      "users" : [
        {
          "name" : var.ssh_user
          "ssh_authorized_keys" : [
            var.ssh_authorized_key
          ]
          "sudo" : "ALL=(ALL) NOPASSWD:ALL"
          "lock_passwd" : true
          "groups" : "sudo"
          "shell" : "/bin/bash"
        }
      ]
    })
  ])

  network_config = yamlencode({
    "network" : {
      "version" : 2
      "ethernets" : {
        "${each.value.eth_devname}" : {
          "addresses" : each.value.ipaddrs
          "gateway4" : each.value.net_gateway
          "nameservers" : {
            "addresses" : each.value.dnsaddrs
          }
        }
      }
    }
  })

  pool = libvirt_pool.lab_cluster.name
}

resource "libvirt_domain" "lab_vms" {
  for_each = local.loop_vms

  name   = each.value.name
  vcpu   = each.value.vcpu
  memory = each.value.ram

  disk {
    volume_id = libvirt_volume.lab_volume[each.value.name].id
  }

  network_interface {
    network_id = libvirt_network.lab_network.id
    hostname   = each.value.name
  }

  cloudinit = libvirt_cloudinit_disk.cloud_init[each.value.name].id

}
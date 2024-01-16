locals {
  expanded_list_of_vms = flatten([
    for index, vm in var.lab_vms : [
      for num in range(vm.quantity) : {
        vm = vm
        # derived_name - if quantity is 1, don't append a number. Just use the default name. Example: "customname"
        #                if quantity is not 1, then append a number. example "customname-3"
        derived_name = vm.quantity == 1 ? vm.name : join("-", [vm.name, num + 1])
      }
    ]
  ])

  loop_vms = {
    for index, vm in local.expanded_list_of_vms :
    vm.derived_name => vm
  }
}

resource "libvirt_pool" "lab_cluster" {
  name = var.libvirt_pool_name
  type = "dir"
  path = var.libvirt_pool_dir
}

resource "libvirt_network" "lab_network" {
  name   = var.libvirt_network_name
  mode   = "bridge"
  bridge = "br0"
}

resource "libvirt_volume" "cloud_image" {
  name   = "cloud_image.qcow2"
  pool   = libvirt_pool.lab_cluster.name
  source = var.cloud_image
  format = "qcow2"
}

resource "libvirt_volume" "lab_volume" {
  for_each         = local.loop_vms
  name             = "${each.value.derived_name}.qcow2"
  pool             = libvirt_pool.lab_cluster.name
  base_volume_id   = libvirt_volume.cloud_image.id
  base_volume_pool = libvirt_pool.lab_cluster.name
  format           = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  for_each = local.loop_vms

  name = "${each.value.derived_name}.iso"

  meta_data      = yamlencode(each.value.vm.meta_data)
  user_data      = join("\n", ["#cloud-config", yamlencode(each.value.vm.user_data)])
  network_config = yamlencode(each.value.vm.network_config)

  pool = libvirt_pool.lab_cluster.name
}

resource "libvirt_domain" "lab_vms" {
  for_each = local.loop_vms

  name   = each.value.derived_name
  vcpu   = each.value.vm.vcpu
  memory = each.value.vm.ram

  disk {
    volume_id = libvirt_volume.lab_volume[each.value.derived_name].id
  }

  network_interface {
    network_id = libvirt_network.lab_network.id
    hostname   = each.value.derived_name
  }

  cloudinit = libvirt_cloudinit_disk.cloud_init[each.value.derived_name].id

}
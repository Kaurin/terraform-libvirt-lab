locals {
  expanded_list_of_vms = flatten([
    for index, vm in var.lab_vms : [
      for num in range(vm.quantity) : {
        vm = vm
        # derived_name - if quantity is 1, don't append a number. Just use the default name. Example: "customname"
        #                if quantity is not 1, then append a number. example "customname-3"
        derived_name = vm.quantity == 1 ? vm.name : join("-", [vm.name, num + 1])
        # meta_data    - See above comment on clarification on how we append numbers
        meta_data = {
          "instance-id" : vm.quantity == 1 ? vm.meta_data.instance-id : join("-", [vm.meta_data.instance-id, num + 1])
          "local-hostname" : vm.quantity == 1 ? vm.meta_data.local-hostname : join("-", [vm.meta_data.local-hostname, num + 1])
        }
        network_config = vm.network_configs[num]
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
  target = {
    path = var.libvirt_pool_dir
  }
}

resource "libvirt_network" "lab_network" {
  name = var.libvirt_network_name

  forward = {
    mode = "bridge"
  }

  bridge = {
    name = var.bridge_device
  }

  autostart = true
}

resource "libvirt_volume" "cloud_image" {
  name = "cloud_image"
  pool = libvirt_pool.lab_cluster.name
  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      url = var.cloud_image
    }
  }
  # capacity is automatically computed from Content-Length when available
}

resource "libvirt_volume" "lab_volume" {
  for_each = local.loop_vms
  name     = "${each.value.derived_name}.qcow2"
  pool     = libvirt_pool.lab_cluster.name
  capacity = var.capacity

  backing_store = {
    path = libvirt_volume.cloud_image.path
    format = {
      type = "qcow2"
    }
  }

  target = {
    format = {
      type = "qcow2"
    }
  }
}


resource "libvirt_cloudinit_disk" "cloud_init" {
  for_each = local.loop_vms

  name = each.value.derived_name

  meta_data      = yamlencode(each.value.meta_data)
  user_data      = join("\n", ["#cloud-config", yamlencode(each.value.vm.user_data)])
  network_config = yamlencode(each.value.network_config)

}


resource "libvirt_volume" "cloud_init" {
  for_each = local.loop_vms
  name     = "${each.value.derived_name}.iso"
  pool     = libvirt_pool.lab_cluster.name
  target = {
    format = {
      type = "iso"
    }
  }
  create = {
    content = {
      url = libvirt_cloudinit_disk.cloud_init[each.key].path
    }
  }
}

resource "libvirt_domain" "lab_vms" {
  for_each = local.loop_vms
  type     = "kvm"
  name     = each.value.derived_name
  vcpu     = each.value.vm.vcpu

  # `memory` is interpreted in `memory_unit`, which libvirt defaults to KiB.
  # Our variable is in Megabytes, so state the unit explicitly.
  memory      = each.value.vm.ram
  memory_unit = "MiB"

  running = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    boot_devices = [
      {
        "dev" = "hd"
      }
    ]
  }

  cpu = {
    mode = "host-passthrough"
  }

  # Without ACPI the guest cannot bring up devices behind the q35 PCIe root
  # ports, so it never finds its virtio root disk.
  features = {
    acpi = true
    apic = {}
  }

  devices = {
    disks = [
      {
        # Without an explicit driver format libvirt hands the image to qemu as
        # raw, and the guest fails to boot off the qcow2 overlay.
        driver = {
          name = "qemu"
          type = "qcow2"
        }
        source = {
          volume = {
            pool   = libvirt_pool.lab_cluster.name
            volume = libvirt_volume.lab_volume[each.key].name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      },
      {
        device = "cdrom"
        driver = {
          name = "qemu"
          type = "raw"
        }
        source = {
          volume = {
            pool   = libvirt_pool.lab_cluster.name
            volume = libvirt_volume.cloud_init[each.key].name
          }
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
        read_only = true
      }
    ]
    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = libvirt_network.lab_network.name
          }
        }
      }
    ]
    # Cloud images log to ttyS0, so an ISA serial port is what `virsh console`
    # needs; the virtio console (/dev/hvc0) is a secondary device. Leaving
    # `source` unset makes libvirt default it to a pty.
    serials = [
      {
        target = {
          type = "isa-serial"
          port = 0
          model = {
            name = "isa-serial"
          }
        }
      }
    ]
    consoles = [
      {
        target = {
          type = "serial"
          port = 0
        }
      },
      {
        target = {
          type = "virtio"
          port = 1
        }
      }
    ]
  }
}

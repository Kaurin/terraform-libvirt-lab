# Libvirt Lab Terraform module

Terraform module which allows for a relatively quick creation of a lab environment on a Linux host on which libvirt and KVM virtualization are available.

This module is similar to [terraform-libvirt-vm](https://registry.terraform.io/modules/MonolithProjects/vm/libvirt/latest) which is worth checking out to see which one fits your use-case better.

Where this project differs from `terraform-libvirt-vm` is in exposing certain config elements of the `dmacvicar/libvirt` provider as non-guardrailed user-provided maps which allows for more flexibility.

## Testing

Testing host is a Fedora OS with KVM/libvirt installed - TODO

## Limitations
* One source "cloud" image per lab.
* One storage pool per lab
* One network of the "bridged" type per lab

## Prerequisites

* A bridge setup on your host. Defaults to "br0" in this module's config but is customizable.
* A "cloud" flavour image of your favorite Linux distribution downloaded

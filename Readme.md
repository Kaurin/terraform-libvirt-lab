# Libvirt Lab Terraform module

Early development - expect breaking changes

Terraform module which allows for a relatively quick creation of a lab environment. This module uses the [dmacvicar/libvirt](https://github.com/dmacvicar/terraform-provider-libvirt) Terraform provider.

This project is similar to [terraform-libvirt-vm](https://registry.terraform.io/modules/MonolithProjects/vm/libvirt/latest) which is worth checking out to see which one fits your use-case better.

Where this project differs from `terraform-libvirt-vm` is in exposing certain config elements of the `dmacvicar/libvirt` provider as non-guardrailed user-provided maps which allows for more flexibility.

## Testing

Testing host is a Fedora OS with KVM/libvirt installed.

## Limitations
* One source "cloud" image per lab.
* One storage pool
* One network of the "bridged" type
* When using multiples of a single machine, you are required to use DHCP in your network settings. Otherwise all machines will get the same IP (or same set of IPs depending on what you provide).

## Prerequesites

* A bridge setup on your host. Defaults to "br0" in this module's config but is customizable.
* A "cloud" flavour image of your favorite distro downloaded

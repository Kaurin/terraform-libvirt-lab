# Documentation

# KVM and terraform
https://computingforgeeks.com/how-to-provision-vms-on-kvm-with-terraform/

# KVM libvirt provider
https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/

# Bridge on linux's network manager
https://www.cyberciti.biz/faq/how-to-add-network-bridge-with-nmcli-networkmanager-on-linux/

## Bridge with network manager

```bash
nmcli con show
nmcli con add type bridge ifname br0
nmcli con add type bridge-slave ifname enp7s0 master br0
nmcli con show
nmcli con --help
nmcli con down 1364e2b2-1e10-392b-979b-e383ab1aee56  # ----- "Wired network 3"
nmcli con up br0
nmcli con
nmcli con up b9ab0103-aaf3-48ab-8405-45b332986609    # ------ br0
```

# Libvirt and  cloud-init
https://sumit-ghosh.com/posts/create-vm-using-libvirt-cloud-images-cloud-init/

# Common usage patterns for terraform's "for_each"
https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12

# Run local scripts with terraform using null resources

https://devcoops.com/terraform-run-local-commands-scripts/

# Customize root password on a libvirt guest (virt-customize)
https://superuser.com/questions/1497732/what-are-default-user-account-and-password-of-fedora-31-cloud-base-image-for-ope

# Named values for terraform (local paths, root path, module path...)
https://developer.hashicorp.com/terraform/language/expressions/references
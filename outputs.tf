output "lab_pool_name" {
  value       = libvirt_pool.lab_cluster.name
  description = "Libvirt pool name"
}

output "lab_pool_id" {
  value       = libvirt_pool.lab_cluster.id
  description = "Libvirt pool id"
}

output "lab_pool_path" {
  value       = libvirt_pool.lab_cluster.target[*].path
  description = "Libvirt pool path"
}

output "lab_network_name" {
  value       = libvirt_network.lab_network.name
  description = "Libvirt network name"
}

output "lab_network_id" {
  value       = libvirt_network.lab_network.id
  description = "Libvirt network ID"
}

output "lab_network_bridge" {
  value       = libvirt_network.lab_network.bridge
  description = "Libvirt network bridge"
}

output "lab_cloud_image_name" {
  value       = libvirt_volume.cloud_image.name
  description = "Libvirt cloud image ISO name"
}

output "lab_cloud_image_id" {
  value       = libvirt_volume.cloud_image.id
  description = "Libvirt cloud image id"
}

output "lab_cloud_image_pool" {
  value       = libvirt_volume.cloud_image.pool
  description = "Libvirt cloud image pool"
}

output "lab_vm_volume_names" {
  value       = [for volume in libvirt_volume.lab_volume : volume.name]
  description = "Libvirt VM volume names"
}

output "lab_vm_volume_ids" {
  value       = [for volume in libvirt_volume.lab_volume : volume.id]
  description = "Libvirt VM volume ids"

}

output "lab_cloud_init_ids" {
  value       = [for cloudinit in libvirt_cloudinit_disk.cloud_init : cloudinit.id]
  description = "Libvirt cloud-init ISO image IDs"
}

output "lab_cloud_init_names" {
  value       = [for cloudinit in libvirt_cloudinit_disk.cloud_init : cloudinit.name]
  description = "Libvirt cloud-init ISO image names"
}

output "lab_cloud_init_user_data" {
  value       = [for cloudinit in libvirt_cloudinit_disk.cloud_init : cloudinit.user_data]
  description = "Libvirt cloud-init ISO image userdata"

}

output "lab_cloud_init_meta_data" {
  value       = [for cloudinit in libvirt_cloudinit_disk.cloud_init : cloudinit.meta_data]
  description = "Libvirt cloud-init ISO image metadata"

}

output "lab_cloud_init_network_configs" {
  value       = [for cloudinit in libvirt_cloudinit_disk.cloud_init : cloudinit.network_config]
  description = "Libvirt cloud-init ISO image network_config"

}

output "lab_vm_names" {
  value       = [for vm in libvirt_domain.lab_vms : vm.name]
  description = "Libvirt VM names"
}

output "lab_vm_ids" {
  value       = [for vm in libvirt_domain.lab_vms : vm.id]
  description = "Libvirt VM IDs"
}

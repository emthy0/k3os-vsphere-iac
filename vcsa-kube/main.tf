# Configure the vSphere provider

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.3"
    }
  }
}


provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}


resource "vsphere_folder" "folder" {
  path          = "k8s"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_virtual_machine" "master_template" {
  name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.master_vm-template-name}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# data "vsphere_virtual_machine" "worker_template" {
#   name          = "/${var.vsphere_datacenter}/vm/${var.vsphere_template_folder}/${var.worker_vm-template-name}"
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }


resource "vsphere_virtual_machine" "k3os-master" {
  count                = var.master_count
  name                 = "${var.master_name}-${count.index}"
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  folder               = vsphere_folder.folder.path
  num_cpus             = var.master_cpu
  num_cores_per_socket = var.master_cores-per-socket
  memory               = var.master_ram
  guest_id             = var.master_vm-guest-id
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.master_template.network_interface_types[0]
  }
  disk {
    label            = "${var.master_name}-${count.index}-disk"
    thin_provisioned = data.vsphere_virtual_machine.master_template.disks.0.thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.master_template.disks.0.eagerly_scrub
    size             = var.master_disksize == "" ? data.vsphere_virtual_machine.master_template.disks.0.size : var.master_disksize
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.master_template.id
    # customize {
    #   linux_options {
    #     host_name = "${var.master_name}-${count.index}"
    #     domain    = "${var.master_name}.thegoose"
    #   }
    #   network_interface {
    #     # ipv4_address = cidrhost("192.168.50.200/29", count.index)
    #     # ipv4_netmask = 24
    #   }
    #   # ipv4_gateway = "192.168.50.1"
    # }

  }
  lifecycle {
    ignore_changes = [
      annotation,
      clone[0].template_uuid,
      clone[0].customize[0].dns_server_list,
      clone[0].customize[0].network_interface[0]
    ]
  }
}

# resource "vsphere_virtual_machine" "k3os-worker" {
#   count = var.worker_count
#   name             = "${var.worker_name}-${count.index}"
#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   datastore_id     = data.vsphere_datastore.datastore.id
#   folder = vsphere_folder.folder.path
#   num_cpus             = var.worker_cpu
#   num_cores_per_socket = var.worker_cores-per-socket
#   memory               = var.worker_ram
#   guest_id             = var.worker_vm-guest-id
#   network_interface {
#     network_id   = data.vsphere_network.network.id
#     adapter_type = data.vsphere_virtual_machine.worker_template.network_interface_types[0]
#   }
#   disk {
#     label            = "${worker_var.name}-${count.index}-disk"
#     thin_provisioned = data.vsphere_virtual_machine.worker_template.disks.0.thin_provisioned
#     eagerly_scrub    = data.vsphere_virtual_machine.worker_template.disks.0.eagerly_scrub
#     size             = var.worker_disksize == "" ? data.vsphere_virtual_machine.worker_template.disks.0.size : var.worker_disksize 
#   }
#   clone {
#     template_uuid = data.vsphere_virtual_machine.worker_template.id
#   }
#   lifecycle {
#     ignore_changes = [
#       annotation,
#       clone[0].template_uuid,
#       clone[0].customize[0].dns_server_list,
#       clone[0].customize[0].network_interface[0]
#     ]
#   }
# }

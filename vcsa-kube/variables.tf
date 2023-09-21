
variable "vsphere_server" {
  type = string
  description = "The vSphere server to connect to"
}

variable "allow_unverified_ssl" {
  type = bool
  description = "Allow unverified SSL certificates when connecting to vSphere"
  default = true
}

variable "vsphere_user" {
  type = string
  description = "The vSphere user to connect as"
}

variable "vsphere_password" {
  type = string
  description = "The vSphere password to connect with"
}

variable "vsphere_datacenter" {
  type = string
  description = "The vSphere datacenter to deploy to"
}

variable "vsphere_datastore" {
  type = string
  description = "The vSphere datastore to deploy to"
}

variable "vsphere_compute_cluster" {
  type = string
  description = "The vSphere compute cluster to deploy to"
}

variable "vsphere_network" {
  type = string
  description = "The vSphere network to deploy to"
}

variable "vsphere_template_folder" {
  type = string
  description = "Folder of k3os vm template"
}

variable "worker_vm-template-name" {  
  type = string
  description = "Name of k3os worker vm template"
}

variable "master_vm-template-name" {  
  type = string
  description = "Name of k3os master vm template"
}

variable "worker_count" {
  type = number
}

variable "worker_name" {
  type = string
}

variable "worker_cpu" {
  type = number
}

variable "worker_cores-per-socket" {
  type = number
}

variable "worker_ram" {
  type = number
}

variable "worker_vm-guest-id" {
  type = string
  default = "other4xLinux64Guest"
}

variable "worker_disksize" {
  type = number
}

variable "master_count" {
  type = number
}

variable "master_name" {
  type = string
}

variable "master_cpu" {
  type = number
}

variable "master_cores-per-socket" {
  type = number
}

variable "master_ram" {
  type = number
}

variable "master_vm-guest-id" {
  type = string
  default = "other4xLinux64Guest"
}

variable "master_disksize" {
  type = number
}
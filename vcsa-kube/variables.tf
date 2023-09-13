
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
  
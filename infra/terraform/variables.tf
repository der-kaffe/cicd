variable "storage_pool" { default = "default" }
variable "path_to_image" { default = "/home/juanc/vmstore/images" }
variable "debian_image" { default = "debian-12-genericcloud-amd64.qcow2" }

variable "hostname" { default = "debian-node1" }
variable "ip" { default = "192.168.122.101" }
variable "gateway" { default = "192.168.122.1" }
variable "memory" { default = 1024 }
variable "vcpus" { default = 1 }

variable "size_disk1" { default = 10 * 1024 * 1024 * 1024 }


variable "network_name" { default = "default" }
variable "domain" { default = "midominio.org" }

resource "tls_private_key" "debian_key" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.debian_key.private_key_openssh
  filename        = "${path.module}/id_ed25519_debian"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content  = tls_private_key.debian_key.public_key_openssh
  filename = "${path.module}/id_ed25519_debian.pub"
}

resource "libvirt_volume" "os_image" {
  name   = "debian"
  pool   = var.storage_pool
  source = "${var.path_to_image}/${var.debian_image}"
  format = "qcow2"
}

resource "libvirt_volume" "node_disk" {
  name           = "${var.hostname}-disk.qcow2"
  pool           = var.storage_pool
  base_volume_id = libvirt_volume.os_image.id
  format         = "qcow2"
  size           = var.size_disk1
}

resource "libvirt_cloudinit_disk" "cloud_init" {
  name = "${var.hostname}-cloudinit.iso"
  pool = var.storage_pool


  user_data = templatefile("${path.module}/config/cloud_init.cfg", {
    hostname = var.hostname
    fqdn     = "${var.hostname}.${var.domain}"
    ssh_key  = trimspace(tls_private_key.debian_key.public_key_openssh)
  })
  network_config = templatefile("${path.module}/config/network_config.cfg", {
    ip1     = var.ip
    gateway = var.gateway
  })

  meta_data = jsonencode({
    instance-id    = var.hostname
    local-hostname = var.hostname
  })
}

resource "libvirt_domain" "domain-alpine" {
  name   = var.hostname
  memory = var.memory
  vcpu   = var.vcpus


  boot_device {
    dev = ["hd", "cdrom"]
  }

  disk {
    volume_id = libvirt_volume.node_disk.id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = false
    addresses      = []
  }

  cloudinit = libvirt_cloudinit_disk.cloud_init.id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}





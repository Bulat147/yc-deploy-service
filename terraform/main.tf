terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.80.0"
    }
    telegram = {
      source  = "yi-jiayu/telegram"
      version = "0.3.1"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id                = var.cloud_id
  folder_id               = var.folder_id
  service_account_key_file = pathexpand(var.key_file_path)
  zone                     = "ru-central1-c"
}

resource "yandex_vpc_network" "network" {
  name = "network-29-0"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet-29-0"
  zone           = var.zone
  v4_cidr_blocks = ["192.168.29.0/24"]
  network_id     = yandex_vpc_network.network.id
}

resource "yandex_compute_disk" "boot_disk" {
  name     = "vm-boot-disk"
  type     = "network-ssd"
  image_id = "fd8vjqu92c0hufsafn1i"
  size     = 10
  zone = var.zone
}

resource "yandex_compute_instance" "vm" {
  name = "deploy-vm"
  platform_id = "standard-v3"
  hostname = "ubuntu"
  zone = var.zone

  resources {
    cores  = 2
    memory = 4
    core_fraction = 100
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_pub_path)}}"
  }
}

output "server_ip" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}


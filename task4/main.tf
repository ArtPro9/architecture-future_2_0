terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.94"
    }
  }
  backend "local" {
    path = "state.tfstate"
  }
}

provider "yandex" {
  cloud_id  = var.yc_cloud
  folder_id = var.yc_folder
  zone      = var.yc_zone
  token     = var.yc_token
}

resource "null_resource" "demo_mode" {
  count = var.deploy_real ? 0 : 1
  triggers = {
    run_id = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Демо-режим: инфраструктура не поднимается'"
  }
}

resource "yandex_iam_service_account" "deployer" {
  count       = var.deploy_real ? 1 : 0
  name        = "deploy-sa"
  description = "Сервисный аккаунт для CI/CD деплоя"
}

resource "yandex_vpc_network" "core_net" {
  count = var.deploy_real ? 1 : 0
  name  = "core-network"
}

resource "yandex_vpc_subnet" "core_subnet" {
  count          = var.deploy_real ? 1 : 0
  name           = "core-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.core_net[0].id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

data "yandex_compute_image" "os_image" {
  count  = var.deploy_real ? 1 : 0
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "boot_disk" {
  count    = var.deploy_real ? 1 : 0
  name     = "vm-disk"
  type     = "network-ssd"
  zone     = var.yc_zone
  size     = 1024
  image_id = data.yandex_compute_image.os_image[0].image_id
}

resource "yandex_compute_instance" "compute_node" {
  count = var.deploy_real ? 1 : 0
  name  = "main-node"
  zone  = var.yc_zone

  resources {
    cores  = 4
    memory = 16
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk[0].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.core_subnet[0].id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/ssh_key.pub")}"
  }
}

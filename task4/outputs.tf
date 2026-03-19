output "run_mode" {
  description = "Текущий режим: demo или production"
  value       = var.deploy_real ? "production" : "demo"
}

output "sa_identity" {
  description = "Идентификатор сервисного аккаунта"
  value       = var.deploy_real ? yandex_iam_service_account.deployer[0].id : "не создан"
}

output "node_id" {
  description = "Идентификатор вычислительной ноды"
  value       = var.deploy_real ? yandex_compute_instance.compute_node[0].id : "не создан"
}

output "node_ip" {
  description = "Публичный адрес ноды"
  value       = var.deploy_real ? yandex_compute_instance.compute_node[0].network_interface[0].nat_ip_address : "не создан"
}

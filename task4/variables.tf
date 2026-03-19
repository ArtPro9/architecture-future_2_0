variable "deploy_real" {
  description = "Создавать реальную инфраструктуру или оставить заглушку"
  type        = bool
  default     = false
}

variable "yc_token" {
  description = "OAuth-токен для Yandex Cloud"
  type        = string
  default     = ""
}

variable "yc_cloud" {
  description = "Идентификатор облака"
  type        = string
  default     = ""
}

variable "yc_folder" {
  description = "Идентификатор каталога"
  type        = string
  default     = ""
}

variable "yc_zone" {
  description = "Географическая зона для ресурсов"
  type        = string
  default     = "ru-central1-a"
}

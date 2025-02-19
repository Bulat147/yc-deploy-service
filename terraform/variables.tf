variable "cloud_id" {
  description = "Идентификатор облака"
  type        = string
}

variable "folder_id" {
  description = "Идентификатор директории"
  type        = string
}

variable "key_file_path" {
  description = "Путь до ключа сервисного аккаунта"
  type = string
}

variable "zone" {
  description = "Зона доступности подсети"
  type = string
}

variable "ssh_pub_path" {
  description = "Путь до публичного ключа ssh"
  type = string
}


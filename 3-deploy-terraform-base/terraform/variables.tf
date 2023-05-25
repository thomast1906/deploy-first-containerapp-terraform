variable "app_name" {
  type        = string
  description = "name of the app"
  default     = "firstcontainerapp"
}

variable "location" {
  type        = string
  description = "Location of Resources"
  default     = "westus"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "production"
}


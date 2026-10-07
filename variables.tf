variable "render_api_key" {
  type      = string
  sensitive = true
}

variable "render_owner_id" {
  type = string
}

variable "clerk_authority" {
  type = string
}

variable "clerk_publishable_key" {
  type = string
}

variable "database_connection_string" {
  type      = string
  sensitive = true
}

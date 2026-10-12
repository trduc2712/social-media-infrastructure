provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

provider "vercel" {
  api_token = var.vercel_api_token
}

provider "b2" {
  application_key_id = var.backblaze_application_key_id
  application_key    = var.backblaze_application_key
}

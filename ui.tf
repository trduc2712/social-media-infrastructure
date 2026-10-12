resource "vercel_project" "ui" {
  name         = "social-media-ui-staging"
  framework    = "vite"
  node_version = "22.x"

  git_repository = {
    type              = "github"
    repo              = "trduc2712/social-media-ui"
    production_branch = "main"
  }
}

resource "vercel_project_domain" "ui" {
  project_id = vercel_project.ui.id
  domain     = "trduc-social-media-ui-staging.vercel.app"
}

resource "vercel_project_environment_variable" "api_base_url" {
  project_id = vercel_project.ui.id
  key        = "VITE_API_BASE_URL"
  value      = render_web_service.api.url
  target     = ["production"]
  sensitive  = false
}

resource "vercel_project_environment_variable" "clerk_publishable_key" {
  project_id = vercel_project.ui.id
  key        = "VITE_CLERK_PUBLISHABLE_KEY"
  value      = var.clerk_publishable_key
  target     = ["production"]
  sensitive  = false
}

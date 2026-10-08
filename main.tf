terraform {
  cloud {
    organization = "trduc2712"

    workspaces {
      name = "social-media-staging"
    }
  }

  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.9"
    }

    vercel = {
      source  = "vercel/vercel"
      version = "~> 5.19"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

provider "vercel" {
  api_token = var.vercel_api_token
}

locals {
  ui_origin_custom = "https://${vercel_project_domain.ui.domain}"
  ui_origin_auto   = "https://${vercel_project.ui.name}.vercel.app"
}

resource "render_web_service" "api" {
  name   = "social-media-api-staging"
  plan   = "free"
  region = "singapore"
  runtime_source = {
    docker = {
      repo_url            = "https://github.com/trduc2712/social-media-api"
      branch              = "main"
      auto_deploy         = true
      auto_deploy_trigger = "checksPass"
    }
  }
}

resource "render_env_group" "api" {
  name = "social-media-api-staging"

  env_vars = {
    ASPNETCORE_ENVIRONMENT              = { value = "Staging" }
    ASPNETCORE_HTTP_PORTS               = { value = "10000" }
    ApiDocumentation__Enabled           = { value = "true" }
    Clerk__Authority                    = { value = var.clerk_authority }
    Clerk__PublishableKey               = { value = var.clerk_publishable_key }
    ConnectionStrings__Default          = { value = var.database_connection_string }
    ASPNETCORE_FORWARDEDHEADERS_ENABLED = { value = "true" }
    Clerk__AuthorizedParties__0         = { value = render_web_service.api.url }
    Clerk__AuthorizedParties__1         = { value = local.ui_origin_custom }
    Clerk__AuthorizedParties__2         = { value = local.ui_origin_auto }
    Cors__AllowedOrigins__0             = { value = local.ui_origin_custom }
    Cors__AllowedOrigins__1             = { value = local.ui_origin_auto }
  }
}

resource "render_env_group_link" "api" {
  env_group_id = render_env_group.api.id
  service_ids  = [render_web_service.api.id]
}

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

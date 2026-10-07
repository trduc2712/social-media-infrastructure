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
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

resource "render_web_service" "api" {
  name   = "social-media-api-staging"
  plan   = "free"
  region = "singapore"
  runtime_source = {
    docker = {
      repo_url    = "https://github.com/trduc2712/social-media-api"
      branch      = "main"
      auto_deploy = true
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
  }
}

resource "render_env_group_link" "api" {
  env_group_id = render_env_group.api.id
  service_ids  = [render_web_service.api.id]
}

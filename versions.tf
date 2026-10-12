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

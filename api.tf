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
    Storage__ServiceUrl                 = { value = local.storage_service_url }
    Storage__Region                     = { value = local.storage_region }
    Storage__BucketName                 = { value = b2_bucket.uploads.bucket_name }
    Storage__AccessKeyId                = { value = b2_application_key.api.application_key_id }
    Storage__SecretAccessKey            = { value = b2_application_key.api.application_key }
  }
}

resource "render_env_group_link" "api" {
  env_group_id = render_env_group.api.id
  service_ids  = [render_web_service.api.id]
}

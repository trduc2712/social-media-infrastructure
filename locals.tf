locals {
  ui_origin_custom = "https://${vercel_project_domain.ui.domain}"
  ui_origin_auto   = "https://${vercel_project.ui.name}.vercel.app"

  storage_service_url = data.b2_account_info.current.s3_api_url
  storage_region      = regex("s3\\.([^.]+)\\.", local.storage_service_url)[0]
}

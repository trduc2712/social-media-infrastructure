locals {
  ui_origin_custom = "https://${vercel_project_domain.ui.domain}"
  ui_origin_auto   = "https://${vercel_project.ui.name}.vercel.app"
}

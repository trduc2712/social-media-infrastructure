data "b2_account_info" "current" {}

resource "b2_bucket" "uploads" {
  bucket_name = "trduc2712-socialmedia-staging-uploads"
  bucket_type = "allPrivate"

  cors_rules {
    cors_rule_name     = "staging-ui"
    allowed_origins    = [local.ui_origin_custom, local.ui_origin_auto]
    allowed_operations = ["s3_put", "s3_get", "s3_head"]
    allowed_headers    = ["*"]
    expose_headers     = ["etag"]
    max_age_seconds    = 3600
  }

  lifecycle_rules {
    file_name_prefix                                       = ""
    days_from_starting_to_canceling_unfinished_large_files = 1
  }
}

resource "b2_application_key" "api" {
  key_name     = "trduc2712-socialmedia-staging-api"
  bucket_ids   = [b2_bucket.uploads.bucket_id]
  capabilities = ["listBuckets", "listFiles", "readFiles", "writeFiles", "deleteFiles"]
}

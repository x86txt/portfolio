# let's create the necessary kms keys for our s3 buckets

resource "aws_kms_key" "devsec0ps-static-site-kms" {
  description             = "KMS key for devsec0ps static site s3 bucket"
  deletion_window_in_days = 10
}

resource "aws_kms_key" "devsec0ps-alb-logs-kms" {
  description             = "KMS key for devsec0ps alb logs bucket"
  deletion_window_in_days = 10
}
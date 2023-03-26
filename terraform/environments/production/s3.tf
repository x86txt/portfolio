# let's do the initial s3 bucket configuration, static site config has been deprecated to another resource
resource "aws_s3_bucket" "devsec0ps-static-site" {

  bucket = "devsec0ps-static-site"
}

# let's use a unique kms key for encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "devsec0ps-static-site" {
  bucket = aws_s3_bucket.devsec0ps-static-site.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.devsec0ps-static-site-kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# let's make sure we're not exposing resources publicly, the ALB will handle end-user traffic termination
resource "aws_s3_bucket_acl" "devsec0ps-static-site" {

  bucket = aws_s3_bucket.devsec0ps-static-site.id
  acl    = "private"
}

# versioning will be handled by github, let's disable this to save cost and K.I.S.S.
resource "aws_s3_bucket_versioning" "devsec0ps-static-site" {

  bucket = aws_s3_bucket.devsec0ps-static-site.id

  versioning_configuration {
    status = "Disabled"
  }
}

# let's configure our s3 bucket for static site hosting.
resource "aws_s3_bucket_website_configuration" "devsec0ps-static-site" {

  bucket = aws_s3_bucket.devsec0ps-static-site.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# let's lock down CORS to only the methods this simple static site needs.
resource "aws_s3_bucket_cors_configuration" "devsec0ps-static-site" {

  bucket = aws_s3_bucket.devsec0ps-static-site.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://devsec0ps.ninja"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# finally, let's create an s3 nucket for our alb logs
resource "aws_s3_bucket" "devsec0ps-alb-logs" {

  bucket = "devsec0ps-alb-logs"
  force_destroy = true

}

# let's use a unique kms key for encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "devsec0ps-alb-logs" {
  bucket = aws_s3_bucket.devsec0ps-alb-logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.devsec0ps-alb-logs-kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# let's make sure our logs aren't accidentally published publicly
resource "aws_s3_bucket_acl" "devsec0ps-alb-logs" {

  bucket = aws_s3_bucket.devsec0ps-alb-logs.id
  acl    = "private"
}

# we don't need versioning for logs, let's disable it to be cost conscious
resource "aws_s3_bucket_versioning" "devsec0ps-alb-logs" {

  bucket = aws_s3_bucket.devsec0ps-alb-logs.id

  versioning_configuration {
    status = "Disabled"
  }
}


## This is a sanitized Terraform project that I built for fun.

- This is a simple S3 static site behind and ALB and Cloudfront. The ALB isn't necessary, but I wanted to include it for learning purposes, because they're used frequently.

- This code will do the following
  - create an s3 bucket for Terraform project sharing locks.
  - create an s3 bucket and enable static website hosting.
  - create an s3 bucket to hold the ALB log files.
  - set cors, encryption, and versioning on the buckets.
  - create a unique KMS key for each s3 bucket.
  - create an ALB which sits in front of the S3 bucket.
  - create a Cloudfront distribution which sits in front of the ALB.
  - create a public TLS certificate, set the TLS policy to the modern 2021 policy.
  - DNS validate the TLS certificate via a route 53 TXT entry.
  - create the necessary DNS entries for accessing the site via www.domain.com and domain.com.

<p align="center">
  <img src="./images/terraform.png" width="800" title="Terraform">
</p>
&nbsp;  
&nbsp;  
> Example of a simple but organized way to provision a static site on AWS.  
&nbsp;  
&nbsp;  
**This code will do the following:** 

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

**to-dos:**  

- modularize the code so you can deploy to dev, staging, and prod via tags.
- add a call to the Github repo to push the HTML code once the Terraform deploy is successful.
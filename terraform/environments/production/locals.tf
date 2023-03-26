## aws provides a handy list of cloudfront ips for us to ingest
data "aws_ip_ranges" "cloudfront" {
  regions  = ["global"]
  services = ["cloudfront"]
}

## we need to chunk this into a list of lists to create multiple security groups,
## because security groups only support 60 IPs or subnets
locals {
  chunks_v4 = chunklist(data.aws_ip_ranges.cloudfront.cidr_blocks, 60)
}


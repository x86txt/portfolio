> **Warning**
> This is a copy of a private repo and does not include the necessary GitHub Secrets to build and push successfully. Further, the Actions have had .disabled appended to their filenames to disable automatic execution.

![project description](./docs/images/github.svg) & ![project description](./docs/images/goaccess.svg) & ![project description](./docs/images/lambda.svg)

![ci](https://github.com/x86txt/goaccess/actions/workflows/actions.yml/badge.svg)

A workflow that compiles an Ubuntu Docker container for AWS Lambda usage, that also includes [GoAccess](https://goaccess.io/) and the AWS CLI. 

## Overview  

The container is pushed to ECR and utilized by an ARM64 Lambda to pull Cloudfront logs from S3, execute GoAccess on them, push the resulting HTML file to a static website S3 bucket, and then the container invalidates the Cloudfront cache for the report.html file as a last step. 

## Details  

The Lambda is executed once every 24 hours by a simple EventBridge cron pattern: ```0 00 * * ? *```

The Github Action refreshes the Lambda with the most recent image when the Docker container changes - changes are detected via push to the repo and the pipeline takes over from there.

We monitor the Lambda for failures using a simple CloudWatch metric match condition (```if lambda errors > 0 in last 60s```), which if matched will send an email via SNS.

## CI/CD  

To avoid GitHub buildx delays (x86_64 -> ARM64) we utilize a [self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) running on an [AWS Graviton 3](https://aws.amazon.com/ec2/graviton/) t4g.micro instance.

We make use of the following GitHub Actions in this workflow[^1]:

- [actions/checkout@v3](https://github.com/actions/checkout)  
- [aws-actions/configure-aws-credentials@v2](https://github.com/aws-actions/configure-aws-credentials)  
- [aws-actions/amazon-ecr-login@v1](https://github.com/aws-actions/amazon-ecr-login)  
- [int128/deploy-lambda-action@v1](https://github.com/int128/deploy-lambda-action)  

[^1]: <b> PSA: </b> I always lock actions to the commit hash for security purposes, see [Security hardening for Github Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).
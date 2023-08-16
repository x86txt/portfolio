# this is an example of a terraform re-usable module project

> [!NOTE]  
> I purposefully chose more common technologies for this project, to complement my more modern [serverless fargate project](https://github.com/x86txt/portfolio/tree/main/aws/fargate).


This project consists of the following:

- Windows EC2 instance
- Microsoft SQL Server RDS instance
- Custom VPC Endpoint for access to services on EC2 instance
- VPC with three subnets: web/frontend, ec2, sql
- Security groups that only allow the absolute minimum access to each subnet that is required for funcationality.
  - EC2 -> SQL, FE -> EC2, VPCE -> FE

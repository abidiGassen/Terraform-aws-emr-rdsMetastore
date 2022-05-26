## Terraform_Emr_ExternalMetastore


A better Terraform solution to create an AWS EMR cluster, including:
   - S3(Cluster Logs)
   - RDS(External Hive Metastore Database)
   - IAM(Roles with AWS Managed Policies)
   - EMR(Autoscaling disabled)


Structure

```
 ├── modules
 │   ├── emr
 │   │   ├── main.tf
 │   │   ├── outputs.tf
 │   │   ├── templates
 │   │   │   └── configurations.json.tpl
 │   │   └── variables.tf
 │   ├── rds-metastore
 │   │   ├── main.tf
 │   │   ├── outputs.tf
 │   │   └── variables.tf
 │   └── s3
 │       ├── main.tf
 │       ├── outputs.tf
 │       └── variables.tf
 ├── README.md
 ├── main.tf
 ├── outputs.tf
 └── variables.tf
 ```
 

This repository is customly made to build an AWS infrastructure that goes with Delta's framework for writing benchmarks to measure Delta's performance
(https://github.com/delta-io/delta/tree/master/benchmarks)

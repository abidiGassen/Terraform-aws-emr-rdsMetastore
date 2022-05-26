## Terraform_Emr_ExternalMetastore


A better Terraform solution to create an AWS EMR cluster, including:
   - S3 (Cluster Logs)
   - RDS (External Hive Metastore Database)
   - IAM (Roles with AWS Managed Policies)
   - EMR


Structure:

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
(https://github.com/delta-io/delta/tree/master/benchmarks):

# Create external Hive Metastore using Amazon RDS
Create an external Hive Metastore in a MySQL database using Amazon RDS with the following specifications:
- MySQL 8.0.15 on a `db.m5.large`.
- General purpose SSDs `gp2`  no Autoscaling storage.
- Non-empty password for admin `(default : adminadmin)`.
- Same region, VPC, subnet as those you will run the EMR cluster. `default : Region us-west-2`

# Create EMR cluster
Create an EMR cluster that connects to the external Hive Metastore with the following specifications:
- EMR version `6.5.0` having `Apache Spark 3.1`
- Master - `i3.2xlarge`
- Workers - `1 x i3.2xlarge` (or 16 worker if you are not testing by running the 1GB benchmark).
- Hive-site configuration to connect to the Hive Metastore.
- Same region, VPC, subnet as those you will run the EMR cluster. `default : Region us-west-2`
- No autoscaling, and default EBS storage.

# Prepare S3 bucket
Create a new S3 bucket `default name : benchmarksbucket1919` which is in the same region your EMR cluster `default : Region us-west-2`.

# Terraform OUTPUTS :

emr_cluster_master_public_dns = `ec2-54-190-144-151.us-west-2.compute.amazonaws.com`                                                                                   
rdsmysql_hive_metastore_db_instance_address = `hivemetastore.cbbnoawadxtg.us-west-2.rds.amazonaws.com`                                                                 
rds_mysql_hive_metastore_db_instance_name = `hive_metastore`                                                                                                           
s3_bucket_emr_cluster_id = `benchmarksbucket1919`                                                                                                               

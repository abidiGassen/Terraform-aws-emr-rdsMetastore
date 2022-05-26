## outputs of rds_mysql_hive_metastore
output "rds_mysql_hive_metastore_db_instance_address" {
  description = "The address of the RDS instance"
  value       = "${module.rds_hive_metastore.db_instance_address}"
}

output "rds_mysql_hive_metastore_db_instance_name" {
  description = "The database name"
  value       = "${module.rds_hive_metastore.db_instance_name}"
}

## outputs of s3_bucket_emr_cluster
output "s3_bucket_emr_cluster_id" {
  description = "The name of the bucket."
  value       = "${module.s3_bucket.s3_bucket_id}"
}

## outputs of emr_cluster
output "emr_cluster_master_public_dns" {
  description = "Public DNS of master node"
  value       = "${module.aws_emr_cluster.master_public_dns}"
}
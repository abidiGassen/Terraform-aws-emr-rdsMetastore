provider "aws" {
  profile = "default"
  region = var.region
}

// default VPC and Subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

// external Hive_Metastore
module "rds_hive_metastore" {
  source = "./modules/rds_metastore"

  identifier = "hivemetastore"
  name = "hive_metastore"
  username = "admin"
  password = "adminadmin"
}

// s3 bucket
module "s3_bucket" {
  source = "./modules/s3"

  bucket = "benchmarksbucket1919"
}

// Defauls SG
resource "aws_default_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    protocol = -1
    self = true
    from_port = 0
    to_port = 0
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

//my IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

// Master
resource "aws_security_group" "emr_cluster_master" {
  name = "emr_cluster_sg_master"
  vpc_id = "${data.aws_vpc.default.id}"
  revoke_rules_on_delete = true

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "emr_cluster_sg_master"
    Environment = "${var.environment}"
  }
}

// Slave
resource "aws_security_group" "emr_cluster_slave" {
  name = "emr_cluster_sg_slave"
  vpc_id = "${data.aws_vpc.default.id}"
  revoke_rules_on_delete = true

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "emr_cluster_sg_slave"
    Environment = "${var.environment}"
  }
}

// EMR cluster
module "aws_emr_cluster" {
  source = "./modules/emr"

  cluster_name = "benchmarks"
  release_label = "emr-6.5.0"
  applications = [
    "Hadoop",
    "Hive",
    "Spark"]
  subnet_id = tolist(data.aws_subnet_ids.default.ids)[0]
  key_name = "EMR key pair"

  master_instance_type = "i3.xlarge"
  master_instance_count = "1"
  core_instance_type = "i3.xlarge"
  core_instance_count_min = "1"
  # To manually resize the cluster, update this value
  core_volume_size = 32
  # Default value is 32 GiB
  ebs_root_volume_size = 10
  # Default value is 10 GiB

  s3_bucket = "${module.s3_bucket.s3_bucket_id}"

  master_security_group = "${aws_security_group.emr_cluster_master.id}"
  addnl_security_groups = "${aws_default_security_group.default.id}"
  slave_security_group = "${aws_security_group.emr_cluster_slave.id}"

  hive_metastore_address = "${module.rds_hive_metastore.db_instance_address}"
  hive_metastore_name = "${module.rds_hive_metastore.db_instance_name}"
  hive_metastore_user = "${module.rds_hive_metastore.aws_db_instance_username}"
  hive_metastore_pass = "${module.rds_hive_metastore.aws_db_instance_password}"
}
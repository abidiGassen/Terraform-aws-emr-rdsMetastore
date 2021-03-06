// IAM roles for the EMR Cluster to use as a service
data "aws_iam_policy_document" "emr_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "elasticmapreduce.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr_service_role" {
  name = "ElasticMapReduceDefaultServiceRole"
  description = "Managed by Terraform"
  assume_role_policy = "${data.aws_iam_policy_document.emr_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "emr_service_role" {
  role = "${aws_iam_role.emr_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

// IAM roles for Cluster Instances to interact with AWS
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr_ec2_instance_profile" {
  name = "ElasticMapReduceDefaultEC2Role"
  description = "Managed by Terraform"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "emr_ec2_instance_profile" {
  role = "${aws_iam_role.emr_ec2_instance_profile.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_instance_profile" "emr_ec2_instance_profile" {
  name = "${aws_iam_role.emr_ec2_instance_profile.name}"
  role = "${aws_iam_role.emr_ec2_instance_profile.name}"
}

// Configuration file
data "template_file" "configurations" {
  template = "${file("${path.module}/templates/configurations.json.tpl")}"

  vars = {
    hive_metastore_address = "${var.hive_metastore_address}"
    hive_metastore_name = "${var.hive_metastore_name}"
    hive_metastore_user = "${var.hive_metastore_user}"
    hive_metastore_pass = "${var.hive_metastore_pass}"
    hive_stats_autogather = "${var.hive_stats_autogather}"
  }
}

resource "aws_emr_cluster" "benchmarks" {

  name = var.cluster_name
  release_label = "${var.release_label}"
  applications = "${var.applications}"
  log_uri = "s3n://${var.s3_bucket}/logs/"

  ebs_root_volume_size = "${var.ebs_root_volume_size}"

  ec2_attributes {
    subnet_id = "${var.subnet_id}"
    emr_managed_master_security_group = "${var.master_security_group}"
    additional_master_security_groups = "${var.addnl_security_groups}"
    emr_managed_slave_security_group = "${var.slave_security_group}"
    instance_profile = "${aws_iam_instance_profile.emr_ec2_instance_profile.arn}"
    key_name = "${var.key_name}"
  }

  master_instance_group {
    instance_type = "${var.master_instance_type}"
    instance_count = "${var.master_instance_count}"
  }

  core_instance_group {
    instance_type = "${var.core_instance_type}"
    instance_count = "${var.core_instance_count_min}"

    ebs_config {
      size = "${var.core_volume_size}"
      type = "${var.core_volume_type}"
    }
  }

  service_role = "${aws_iam_role.emr_service_role.arn}"
  configurations = "${data.template_file.configurations.rendered}"
  termination_protection = false
  keep_job_flow_alive_when_no_steps = true

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_instance" "master" {
  filter {
    name = "dns-name"
    values = [
      "${aws_emr_cluster.benchmarks.master_public_dns}"]
  }
}
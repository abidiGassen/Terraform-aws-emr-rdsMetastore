variable "cluster_name" {
  description = "The name of the job flow"
  type        = string
}

variable "release_label" {
  description = "The release label for the Amazon EMR release"
  type        = string
}

variable "s3_bucket" {
  description = "The name of S3 bucket"
  type        = string
}

variable "hive_metastore_address" {
  description = "The DNS name of Hive Metastore RDS instance"
  type        = string
}

variable "hive_metastore_name" {
  description = "The DB name of Hive Metastore RDS instance"
  type        = string
}

variable "hive_metastore_user" {
  description = "The User name of Hive Metastore RDS instance"
  type        = string
}

variable "hive_metastore_pass" {
  description = "The Password of Hive Metastore RDS instance"
  type        = string
}

variable "hive_stats_autogather" {
  description = "Switch on/off statistics automatically computed and stored into Hive MetaStore"
  type        = bool
  default     = false
}

variable "applications" {
  description = "The applications installed on this cluster"
  type        = list(string)
  default     = []
}

variable "ebs_root_volume_size" {
  description = "Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance"
  type        = number
  default     = 10
}

variable "subnet_id" {
  description = "VPC subnet id where you want the job flow to launch"
  type        = string
}

variable "master_security_group" {
  description = "Identifier of the Amazon EC2 EMR-Managed security group for the master node"
  type        = string
}

variable "addnl_security_groups" {
  description = "Identifier of the additional security group for the master node"
  type        = string
}

variable "slave_security_group" {
  description = "Identifier of the Amazon EC2 EMR-Managed security group for the slave nodes"
  type        = string
}

variable "key_name" {
  description = "Amazon EC2 key pair that can be used to ssh to the master node as the user called hadoop"
  type        = string
}

variable "master_instance_type" {
  description = "EC2 instance type for all instances in the instance group"
  type        = string
  default     = "m5.xlarge"
}

variable "master_instance_count" {
  description = "Target number of instances for the instance group"
  type        = number
  default     = 1
}

variable "core_instance_type" {
  description = "EC2 instance type for all instances in the instance group"
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_count_min" {
  description = "Minimal target number of Core instances for the instance group"
  type        = number
  default     = 1
}

variable "core_volume_size" {
  description = "Size in GiB of the EBS"
  type        = number
  default     = 32
}

variable "core_volume_type" {
  description = "Type of the EBS"
  type        = string
  default     = "gp2"
}
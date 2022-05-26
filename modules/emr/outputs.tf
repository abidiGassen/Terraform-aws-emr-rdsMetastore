output "master_public_dns" {
  description = "Public DNS name of master node"
  value = "${data.aws_instance.master.public_dns}"
}
output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = element(concat(aws_s3_bucket.benchmarks.*.id, tolist([])), 0)
}
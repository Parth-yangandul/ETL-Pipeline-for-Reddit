# Output the hostname (endpoint) of Redshift Serverless Workgroup
output "redshift_serverless_hostname" {
  description = "Endpoint of the Redshift Serverless workgroup"
  value       = aws_redshiftserverless_workgroup.workgroup.endpoint
}



# Output Redshift Admin Username
output "redshift_username" {
  description = "Admin username for Redshift Serverless"
  value       = aws_redshiftserverless_namespace.namespace.admin_username
  sensitive = true
}

# Output Redshift Admin Password (Sensitive)
output "redshift_password" {
  description = "Admin password for Redshift Serverless"
  value       = var.db_password
  sensitive   = true  # Hides output in the console for security
}

# Output IAM Role assigned to Redshift
output "redshift_role" {
  description = "IAM Role assigned to Redshift Serverless"
  value       = aws_iam_role.redshift_role.name
}

# Output AWS Account ID
data "aws_caller_identity" "current" {}
output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

# Output AWS Region
output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

# Output S3 Bucket Name
output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = var.s3_bucket
}

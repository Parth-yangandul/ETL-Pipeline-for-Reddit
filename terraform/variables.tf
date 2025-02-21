variable "db_password" {
  description = "Password for Redshift master DB user"
  type        = string
  default     = "GSTTEwdtps863.&"
}

variable "s3_bucket" {
  description = "Bucket name for S3"
  type        = string
  default     = "parth-reddit-pipeline-bucket"
}

variable "aws_region" {
  description = "Region for AWS"
  type        = string
  default     = "ap-south-1"
}
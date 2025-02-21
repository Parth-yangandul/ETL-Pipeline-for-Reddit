terraform {
    required_version = ">= 1.2.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
}

# Configure AWS provider
provider "aws" {
    region = var.aws_region
}

# Create a Redshift Serverless namespace
resource "aws_redshiftserverless_namespace" "namespace" {
  namespace_name = "reddit-namespace"
  admin_username = "awsuser"
  admin_user_password = var.db_password
  iam_roles = [aws_iam_role.redshift_role.arn]
}

# Create a Redshift Serverless workgroup
resource "aws_redshiftserverless_workgroup" "workgroup" {
  workgroup_name = "reddit-workgroup"
  namespace_name = aws_redshiftserverless_namespace.namespace.namespace_name
  publicly_accessible = true
  security_group_ids = [aws_security_group.sg_redshift.id]
}

# Configure security group for Redshift Serverless
resource "aws_security_group" "sg_redshift" {
  name        = "sg_redshift"

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM Role for Redshift Serverless to read from S3
resource "aws_iam_role" "redshift_role" {
  name = "RedShiftLoadRole"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })
}

# Create an S3 bucket
resource "aws_s3_bucket" "reddit_bucket" {
  bucket = var.s3_bucket
  force_destroy = true
}

# Set access control of bucket to private
resource "aws_s3_bucket_acl" "s3_reddit_bucket_acl" {
  bucket = aws_s3_bucket.reddit_bucket.id
  acl    = "private"
}

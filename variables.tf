variable "project_name" {
  description = "Short name used as a prefix for all resource names"
  type        = string
  default     = "cloud-data-platform"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to target (emulated by LocalStack)"
  type        = string
  default     = "us-east-1"
}

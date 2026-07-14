output "bucket_name" {
  description = "Name of the S3 bucket used as the data lake"
  value       = aws_s3_bucket.data_lake.bucket
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.s3_processor.function_name
}

output "lambda_role_arn" {
  description = "ARN of the IAM role assumed by the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}

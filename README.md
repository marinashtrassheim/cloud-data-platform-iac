# ☁️ Cloud Data Platform · Infrastructure as Code

**Terraform · LocalStack · S3 · IAM · Lambda**

[![Terraform](https://img.shields.io/badge/terraform-1.8.0-%235835CC?logo=terraform)](https://www.terraform.io/)
[![LocalStack](https://img.shields.io/badge/localstack-3.0+-%234E2DD4?logo=localstack)](https://localstack.cloud/)
[![AWS](https://img.shields.io/badge/aws-emulated-%23FF9900?logo=amazonaws)](https://aws.amazon.com/)

> Production‑ready infrastructure for a serverless data platform, running **fully locally** with a true AWS API emulation.

---

## 📌 Overview

This project provisions a **serverless data processing pipeline** using Infrastructure as Code (IaC).  
All components run inside **LocalStack** — a 100% local AWS emulator — so you can develop, test, and demonstrate cloud skills without any real cloud costs or credentials.

The following AWS services are emulated and fully provisioned by Terraform:

- **S3** – object storage with versioning
- **IAM** – fine‑grained roles and policies
- **Lambda** – Python 3.9 function triggered by API calls

---

## 🧠 Architecture


**Flow:**
1. `terraform apply` creates all resources inside LocalStack.
2. The IAM role grants the Lambda function **read/list** permissions on the S3 bucket.
3. The Lambda function is invoked manually via `curl` or AWS CLI.
4. It returns a JSON response – proving the entire IAM → S3 → Lambda chain works.

---

## 🛠 Tech Stack

| Tool | Purpose |
|------|---------|
| **Terraform** (HCL) | Infrastructure as Code – defines and provisions all resources |
| **LocalStack** | Local AWS cloud emulator (S3, IAM, Lambda APIs) |
| **Python 3.9** | Runtime for the Lambda function |
| **Docker** | Runs LocalStack container |
| **AWS CLI** (optional) | Interact with the local endpoints |

---

## 🚀 Getting Started (Step‑by‑Step)

Follow these instructions exactly — they work on **macOS / Linux / Windows (WSL2)**.

### 1️⃣ Install prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (running)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.5)
- [Python 3.9+](https://www.python.org/downloads/)
- `curl` (usually pre‑installed)

### 2️⃣ Get a free LocalStack auth token

LocalStack now requires a free account for Lambda support.

1. Go to LocalStack Getting Started
2. Sign up / Sign in (GitHub account works)
3. Find your Auth Token in the dashboard (under “Account” → “Auth Token”)
4. Copy the token – it looks like ls-xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

### 3️⃣ Start LocalStack with Lambda support

Run the container with the token and Docker socket access (required for Lambda):
```
docker run -d --name localstack \
  -p 4566:4566 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SERVICES=s3,lambda,iam \
  -e LAMBDA_EXECUTOR=docker \
  -e LOCALSTACK_AUTH_TOKEN=ls-your-token-here \
  localstack/localstack
```

Check that the container is healthy:

```
curl http://localhost:4566/_localstack/health
```

All services (s3, lambda, iam) should show "available".

### 4️⃣ Build the Lambda package 

From the project root:

```
cd lambda_function
zip ../lambda.zip index.py
cd ..
```

### 5️⃣ Deploy the infrastructure

```
terraform init
terraform apply -auto-approve
```
You should see:
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

### 6️⃣ Invoke the Lambda function

```
curl -X POST http://localhost:4566/2015-03-31/functions/s3_file_processor/invocations \
  -H "Content-Type: application/json" \
  -d '{"test": "hello"}'
```

✅ Expected response:

```
{"statusCode":200,"body":"{\"message\": \"Lambda applied successfully!\"}"}
```

🧩 Key Terraform Resources Explained
Resource	What it does
aws_s3_bucket	Creates my-data-platform-bucket with versioning
aws_iam_role	Defines who can assume the Lambda execution role
aws_iam_policy	Grants s3:GetObject and s3:ListBucket on the bucket
aws_lambda_function	Uploads lambda.zip, sets Python runtime and handler
aws_s3_bucket_notification (optional)	Triggers Lambda on new S3 objects
All endpoints are redirected to http://localhost:4566 via the provider configuration – no real AWS API calls are ever made.

🧹 Clean Up
To stop LocalStack and remove all resources:

```
terraform destroy -auto-approve
docker stop localstack && docker rm localstack
```


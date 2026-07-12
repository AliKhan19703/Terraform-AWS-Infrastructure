# Terraform AWS Infrastructure Project

Provisioning a complete AWS environment using Terraform (Infrastructure as Code). This project creates an isolated network with a public subnet, launches an EC2 instance inside it, and provisions an S3 bucket, all defined entirely in code and reproducible with a single command.

## Architecture

<img width="1488" height="992" alt="Architecture_terraform" src="https://github.com/user-attachments/assets/cdbd5b9e-6ed6-445e-8f27-9097267486ef" />

### Resources Created

| Resource | Purpose |
|---|---|
| VPC | Isolated network (10.0.0.0/16) |
| Public Subnet | Network segment for EC2 (10.0.1.0/24) |
| Internet Gateway | Internet access for the VPC |
| Route Table | Routes outbound traffic to the Internet Gateway |
| Route Table Association | Connects the public subnet to the route table |
| Security Group | Allows SSH (22) and HTTP (80) inbound, all outbound |
| EC2 Instance | t2.micro compute instance in the public subnet |
| S3 Bucket | Object storage |

## Why Terraform

In real-world environments, infrastructure is provisioned repeatedly across development, staging, and production. Creating resources manually through the AWS Console is slow, error-prone, and difficult to keep consistent. Terraform solves this by defining infrastructure as code, which makes it:

- Consistent: the same configuration always produces the same environment
- Repeatable: rebuild or replicate the entire setup in minutes
- Version-controlled: infrastructure changes are tracked in Git like application code
- Reviewable: every change is previewed with `terraform plan` before it touches real infrastructure

## Project Structure

```
terraform-aws-project/
├── main.tf              # Resource definitions (VPC, subnet, IGW, SG, EC2, S3)
├── provider.tf          # AWS provider configuration
├── variables.tf         # Input variable declarations
├── terraform.tfvars     # Variable values (region, CIDRs, AMI, instance type)
├── outputs.tf           # Output values (instance public IP, bucket name)
├── versions.tf          # Terraform and provider version constraints
├── .gitignore           # Excludes state files and sensitive data
└── README.md
```

## Prerequisites

- An AWS account
- [Terraform](https://developer.hashicorp.com/terraform/install) v1.5 or later
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2, configured with credentials:

```bash
aws configure
```

Verify authentication:

```bash
aws s3 ls
```

## Usage

Clone the repository and initialize Terraform:

```bash
git clone https://github.com/AliKhan19703/terraform-aws-project.git
cd terraform-aws-project
terraform init
```

Validate and review the execution plan:

```bash
terraform validate
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Terraform will display the plan and prompt for confirmation. Type `yes` to create all 8 resources. On completion, the instance public IP and bucket name are printed as outputs.

## Configuration

Variable values are set in `terraform.tfvars`:

| Variable | Description | Example |
|---|---|---|
| `aws_region` | AWS region to deploy into | `ap-south-1` |
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` |
| `subnet_cidr` | CIDR block for the public subnet | `10.0.1.0/24` |
| `ami_id` | AMI ID for the EC2 instance | `ami-0f58b397bc5c1f2e8` |
| `instance_type` | EC2 instance type | `t2.micro` |
| `bucket_name` | Globally unique S3 bucket name | `my-terraform-bucket-example-123` |

Update `bucket_name` to a unique value before applying, since S3 bucket names must be globally unique.

## Outputs

| Output | Description |
|---|---|
| `instance_public_ip` | Public IP address of the EC2 instance |
| `bucket_name` | Name of the created S3 bucket |

## Cleanup

Always destroy the infrastructure when finished to avoid unnecessary AWS charges:

```bash
terraform destroy
```

Type `yes` when prompted. This removes all resources created by this configuration.

## Security Notes

- The security group allows SSH from `0.0.0.0/0` for demonstration purposes. In a production environment, restrict SSH access to a specific IP address or a bastion host.
- State files (`terraform.tfstate`) may contain sensitive values and are excluded from version control via `.gitignore`. Never commit state files or credentials.
- For team environments, use a remote backend (S3 with DynamoDB state locking) instead of local state.

## Planned Improvements

- Refactor resources into reusable Terraform modules
- Migrate state to a remote backend (S3 + DynamoDB locking)
- Add `tflint` and `checkov` for linting and security scanning

## Author

**Ali Khan**
AWS Certified Solutions Architect - Associate
[GitHub](https://github.com/AliKhan19703) | [LinkedIn](https://linkedin.com/in/ali-khan-389955252)

## Acknowledgments

Based on the hands-on guide "Terraform AWS: Complete Beginner to Practical Guide" by Abdhesh Kumar.

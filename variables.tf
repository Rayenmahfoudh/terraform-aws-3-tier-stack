variable "is_local" {
  description = "Run against LocalStack mock instead of real AWS"
  type        = bool
  default     = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "patientping"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS master password (required for real AWS)"
  type        = string
  sensitive   = true
  default     = "changeme123"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key for EC2 access"
  type        = string
  default     = "~/.ssh/patientping-key.pub"
}

variable "alert_mail" {
  description = "Mail address for cloudwatch alerts"
  type        = string
  default     = "example@mail.com"
}

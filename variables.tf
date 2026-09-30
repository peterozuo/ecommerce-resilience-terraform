variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ecommerce-resilience"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "Public subnet A"
  type        = string
  default     = "10.20.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "Public subnet B"
  type        = string
  default     = "10.20.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "Private subnet A for RDS"
  type        = string
  default     = "10.20.11.0/24"
}

variable "private_subnet_b_cidr" {
  description = "Private subnet B for RDS"
  type        = string
  default     = "10.20.12.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum EC2 instances"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired EC2 instances"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum EC2 instances"
  type        = number
  default     = 4
}

variable "cpu_target" {
  description = "Target average CPU utilization for Auto Scaling"
  type        = number
  default     = 60
}

variable "cpu_alarm_threshold" {
  description = "CPU threshold for CloudWatch alarm"
  type        = number
  default     = 80
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "ecommerce"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
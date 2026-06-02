variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "Public subnet in AZ-a"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "Public subnet in AZ-b"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "Private subnet in AZ-a"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "Private subnet in AZ-b"
  type        = string
}

variable "az_a" {
  description = "Primary AZ"
  type        = string
}

variable "az_b" {
  description = "Secondary AZ"
  type        = string
}

variable "instance_type" {
  description = "EC2 type"
  type        = string
}

variable "my_ip" {
  description = "Your IP for SSH"
  type        = string
}
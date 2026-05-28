variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux AMI"
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
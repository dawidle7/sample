# Variables for AWS region
variable "aws_region" {
  default = "eu-central-1"
}

# VPC CIDR blocks
variable "prod_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "test_vpc_cidr" {
  default = "10.1.0.0/16"
}

# Subnet CIDR blocks for Production
variable "prod_public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "prod_private_subnet_cidr" {
  default = "10.0.2.0/24"
}

# Subnet CIDR blocks for Testing
variable "test_public_subnet_cidr" {
  default = "10.1.1.0/24"
}

variable "test_private_subnet_cidr" {
  default = "10.1.2.0/24"
}

# Availability Zones
variable "prod_availability_zone" {
  default = "eu-central-1a"
}

variable "test_availability_zone" {
  default = "eu-central-1b"
}
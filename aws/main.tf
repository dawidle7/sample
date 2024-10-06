# Provider
provider "aws" {
  region = var.aws_region
  
}

# VPC for Production
resource "aws_vpc" "prod_vpc" {
  cidr_block = var.prod_vpc_cidr
  tags = {
    Name = "prod-vpc"
  }
}

# VPC for Testing
resource "aws_vpc" "test_vpc" {
  cidr_block = var.test_vpc_cidr
  tags = {
    Name = "test-vpc"
  }
}

# Subnets for Production
resource "aws_subnet" "prod_subnet_public" {
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = var.prod_public_subnet_cidr
  availability_zone = var.prod_availability_zone
  tags = {
    Name = "prod-public-subnet"
  }
}

resource "aws_subnet" "prod_subnet_private" {
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = var.prod_private_subnet_cidr
  availability_zone = var.prod_availability_zone
  tags = {
    Name = "prod-private-subnet"
  }
}

# Subnets for Testing
resource "aws_subnet" "test_subnet_public" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.test_public_subnet_cidr
  availability_zone = var.test_availability_zone
  tags = {
    Name = "test-public-subnet"
  }
}

resource "aws_subnet" "test_subnet_private" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.test_private_subnet_cidr
  availability_zone = var.test_availability_zone
  tags = {
    Name = "test-private-subnet"
  }
}

# Internet Gateway for Production
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = {
    Name = "prod-igw"
  }
}

# Internet Gateway for Testing
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "test-igw"
  }
}

# Route Table for Public Subnet in Production
resource "aws_route_table" "prod_public_rt" {
  vpc_id = aws_vpc.prod_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }

  tags = {
    Name = "prod-public-rt"
  }
}

# Route Table for Public Subnet in Testing
resource "aws_route_table" "test_public_rt" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "test-public-rt"
  }
}

# Associate Public Subnet with Route Table in Production
resource "aws_route_table_association" "prod_public_rt_assoc" {
  subnet_id      = aws_subnet.prod_subnet_public.id
  route_table_id = aws_route_table.prod_public_rt.id
}

# Associate Public Subnet with Route Table in Testing
resource "aws_route_table_association" "test_public_rt_assoc" {
  subnet_id      = aws_subnet.test_subnet_public.id
  route_table_id = aws_route_table.test_public_rt.id
}

# Security Group for Production
resource "aws_security_group" "prod_sg" {
  vpc_id = aws_vpc.prod_vpc.id
  name   = "prod-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-sg"
  }
}

# Security Group for Testing
resource "aws_security_group" "test_sg" {
  vpc_id = aws_vpc.test_vpc.id
  name   = "test-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-sg"
  }
}
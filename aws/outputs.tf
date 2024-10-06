# Output VPC IDs
output "prod_vpc_id" {
  value = aws_vpc.prod_vpc.id
}

output "test_vpc_id" {
  value = aws_vpc.test_vpc.id
}

# Output Subnet IDs
output "prod_public_subnet_id" {
  value = aws_subnet.prod_subnet_public.id
}

output "prod_private_subnet_id" {
  value = aws_subnet.prod_subnet_private.id
}

output "test_public_subnet_id" {
  value = aws_subnet.test_subnet_public.id
}

output "test_private_subnet_id" {
  value = aws_subnet.test_subnet_private.id
}

# Output Security Group IDs
output "prod_sg_id" {
  value = aws_security_group.prod_sg.id
}

output "test_sg_id" {
  value = aws_security_group.test_sg.id
}

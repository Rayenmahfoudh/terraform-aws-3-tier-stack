output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = {
    a = aws_subnet.public_a.id
    b = aws_subnet.public_b.id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = {
    a = aws_subnet.private_a.id
    b = aws_subnet.private_b.id
  }
}

output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.address
}

output "db_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}

output "web_instance_id" {
  description = "Web EC2 instance ID"
  value       = aws_instance.web.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

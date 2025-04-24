output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet1_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private-zone1-subnet.id  
}

output "private_subnet2_id" {
  description = "ID of the second private subnet"
  value       = aws_subnet.private-zone2-subnet.id
}
output "public_subnet1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public-zone1-subnet.id
}

output "public_subnet2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.public-zone2-subnet.id
}

# output "private_subnets" {
#   description = "List of private subnet IDs"
#   value       = module.vpc.private_subnets
# }

# output "public_subnet1_id" {
#   description = "ID of the first public subnet"
#   value       = module.vpc.public_subnet1_id
# }
# output "private_subnet1" {
#   description = "List of private subnet IDs"
#   value       = aws.vpc.private_subnets
# }

# output "public_subnets" {
#   description = "List of public subnet IDs"
#   value       = module.vpc.public_subnets
# }




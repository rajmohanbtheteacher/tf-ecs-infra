# outputs.tf
output "vpc_id" {
  value = aws_vpc.gateway_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

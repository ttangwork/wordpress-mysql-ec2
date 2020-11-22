output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "public_subnet_id_for_packer" {
  value = length(aws_subnet.public_subnets.*.id) == 0 ? "" : aws_subnet.public_subnets[0].id
}

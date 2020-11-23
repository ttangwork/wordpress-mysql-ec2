output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

# using conditional as the workaround to this issue:
# https://github.com/terraform-google-modules/terraform-google-cloud-dns/issues/8
output "public_subnet_id_for_packer" {
  value = length(aws_subnet.public_subnets.*.id) == 0 ? "" : aws_subnet.public_subnets[0].id
}

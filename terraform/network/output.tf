output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = { for k, s in aws_subnet.private_subnets : k => s.id }
}

output "public_subnet_ids" {
  value = { for k, s in aws_subnet.public_subnets : k => s.id }
}

# using conditional as the workaround to this issue:
# https://github.com/terraform-google-modules/terraform-google-cloud-dns/issues/8
# Selecting the subnet corresponding to the first AZ in the list for packer.
output "public_subnet_id_for_packer" {
  value = length(var.az_list) == 0 || !can(aws_subnet.public_subnets[var.az_list[0]]) ? "" : aws_subnet.public_subnets[var.az_list[0]].id
}

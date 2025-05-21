# vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", var.network_prefix)
  }
}

locals {
  # Ensure az_list and subnet CIDR lists are of the same length for zipping.
  # This assumes a direct mapping by index.
  public_subnet_az_map = zipmap(var.az_list, var.public_subnet_cidrs)
  private_subnet_az_map = zipmap(var.az_list, var.private_subnet_cidrs)
}

# public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = local.public_subnet_az_map
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}${each.key}"
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-%s", var.network_prefix, each.key),
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = local.private_subnet_az_map
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = format("%s-private-subnet-%s", var.network_prefix, each.key),
  }
}

# elastic ip
resource "aws_eip" "eip" {
  for_each = aws_subnet.public_subnets # Iterate over the public subnets

  tags = {
    Name = format("%s-eip-%s", var.network_prefix, each.key) # each.key here is the AZ identifier from public_subnets map
  }
}

# nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  for_each      = aws_subnet.public_subnets # Iterate over the public subnets
  subnet_id     = each.value.id             # each.value is the public subnet object
  allocation_id = aws_eip.eip[each.key].id  # Reference EIP by the same AZ key

  tags = {
    Name = format("%s-nat-gateway-%s", var.network_prefix, each.key) # each.key is the AZ identifier
  }
}

# internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format("%s-internet-gateway", var.network_prefix)
  }
}

# private route
resource "aws_route_table" "private_route_table" {
  for_each = aws_subnet.private_subnets # Iterate over private subnets (keyed by AZ)
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = format("%s-private-route-table-%s", var.network_prefix, each.key)
  }
}

resource "aws_route" "private_internet" {
  for_each               = aws_route_table.private_route_table # Iterate over AZ-keyed private route tables
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[each.key].id # Match NAT GW by AZ key
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  for_each       = aws_subnet.private_subnets # Iterate over AZ-keyed private subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table[each.key].id # Match RT by AZ key
}


# public route
resource "aws_route_table" "public_route_table" {
  for_each = aws_subnet.public_subnets # Iterate over public subnets (keyed by AZ)
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = format("%s-public-route-table-%s", var.network_prefix, each.key)
  }
}

resource "aws_route" "public_internet" {
  for_each               = aws_route_table.public_route_table # Iterate over AZ-keyed public route tables
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id # Single IGW
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  for_each       = aws_subnet.public_subnets # Iterate over AZ-keyed public subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table[each.key].id # Match RT by AZ key
}

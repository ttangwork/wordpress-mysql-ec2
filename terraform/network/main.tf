# vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", var.app_prefix)
  }
}

# public subnets
resource "aws_subnet" "public_subnets" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}${var.az_list[count.index]}"
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-az%d", var.app_prefix, count.index + 1),
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  count             = var.az_count
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}${var.az_list[count.index]}"
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = format("%s-private-subnet-az%d", var.app_prefix, count.index + 1),
  }
}

# elastic ip
resource "aws_eip" "eip" {
  count = length(aws_subnet.public_subnets[*].id)

  tags = {
    Name = format("%s-eip", var.app_prefix)
  }
}

# nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(aws_subnet.public_subnets[*].id)
  subnet_id     = aws_subnet.public_subnets[count.index].id
  allocation_id = aws_eip.eip[count.index].id

  tags = {
    Name = format("%s-nat-gateway-%s", var.app_prefix, var.az_list[count.index])
  }
}

# internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format("%s-internet-gateway", var.app_prefix)
  }
}

# private route
resource "aws_route_table" "private_route_table" {
  count  = length(aws_subnet.private_subnets[*].id)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format("%s-private-route-table", var.app_prefix)
  }
}

resource "aws_route" "private_internet" {
  count                  = length(aws_subnet.private_subnets[*].id)
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  count          = length(aws_subnet.private_subnets[*].id)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}


# public route
resource "aws_route_table" "public_route_table" {
  count  = length(aws_subnet.public_subnets[*].id)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format("%s-public-route-table", var.app_prefix)
  }
}

resource "aws_route" "public_internet" {
  count                  = length(aws_subnet.public_subnets[*].id)
  route_table_id         = aws_route_table.public_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}

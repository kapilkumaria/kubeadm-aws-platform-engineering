resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = { for index, cidr in var.public_subnet_cidrs : index => cidr }

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[each.key]

  tags = {
    Name        = "${var.project}-${var.environment}-public-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = { for index, cidr in var.private_subnet_cidrs : index => cidr }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name        = "${var.project}-${var.environment}-private-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}


# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-${var.environment}-eip-nat"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name        = "${var.project}-${var.environment}-nat"
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id = each.value.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-private-rt"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

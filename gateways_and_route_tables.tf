# Creating Public Facing Internet Gateway
resource "aws_internet_gateway" "public_internet_gw" {
  vpc_id =  aws_vpc.my_vpc.id

  tags = {
    Name = "public_facing_internet_gateway"
  }
}

# Creating Elastic IP
resource "aws_eip" "elastic_ip" {
  vpc      = true
}

# Creating NAT Gateway
resource "aws_nat_gateway" "gw" {
  depends_on = [aws_internet_gateway.public_internet_gw]
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NAT gw"
  }
}

# Allowing default route table to go to Internet Gateway 
resource "aws_default_route_table" "gw_router" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.public_internet_gw.id
    }

  tags = {
    Name = "default table"
  }
}

# route table for NAT gateway
resource "aws_route_table" "nat_gw_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "nat gw route table"
  }
}
  
# Associating Public Subnet 
resource "aws_route_table_association" "associate_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_default_route_table.gw_router.id
}

# Associating Public Subnet 
resource "aws_route_table_association" "associate_private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.nat_gw_rt.id
}

# Associating Public Subnet 
resource "aws_route_table_association" "associate_private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.nat_gw_rt.id
}


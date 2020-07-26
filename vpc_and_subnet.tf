# Creating new VPC with enabled hostname
resource "aws_vpc" "my_vpc" {
  cidr_block       = "192.168.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name = "my_vpc"
  }
}

# Creating Public Subnet for WordPress 
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.5.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}

# Creating two private subnets because RDS requires minimum 2 availability zones
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.6.0/24"
  availability_zone = "ap-south-1b"
  
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.7.0/24"
  availability_zone = "ap-south-1c"
  
  tags = {
    Name = "private_subnet_2"
  }
}

# Creating Database Subnet group under our VPC
resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds_db"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id ]

  tags = {
    Name = "My DB subnet group"
  }
}


#Create a custom VPC
  resource "aws_vpc" "django-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "MyProjectVPC"
    }
  }

#Create Subnets
  resource "aws_subnet" "Mysubnet01" {
    vpc_id                  = aws_vpc.django-vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "MyPublicSubnet01"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/pc-eks" = "shared"
    }
  }

  resource "aws_subnet" "Mysubnet02" {
    vpc_id                  = aws_vpc.django-vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "MyPublicSubnet02"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/pc-eks" = "shared"
    }
  }

  # Creating Internet Gateway IGW
  resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.django-vpc.id
    tags = {
      "Name" = "MyIGW"
    }
  }

  # Creating Route Table
  resource "aws_route_table" "myroutetable" {
    vpc_id = aws_vpc.django-vpc.id
    tags = {
      "Name" = "MyPublicRouteTable"
    }
  }

  # Create a Route in the Route Table with a route to IGW
  resource "aws_route" "myigw_route" {
    route_table_id         = aws_route_table.myroutetable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.myigw.id
  }

  # Associate Subnets with the Route Table
  resource "aws_route_table_association" "Mysubnet01_association" {
    route_table_id = aws_route_table.myroutetable.id
    subnet_id      = aws_subnet.Mysubnet01.id
  }

  resource "aws_route_table_association" "Mysubnet02_association" {
    route_table_id = aws_route_table.myroutetable.id
    subnet_id      = aws_subnet.Mysubnet02.id
  }

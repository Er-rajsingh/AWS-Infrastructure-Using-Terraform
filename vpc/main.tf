resource "aws_vpc" "vpc-prod" {
  cidr_block = "10.70.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "vpc-prod-1"
  }
}

resource "aws_subnet" "public-subnet" {
  count = length(var.subnet_ids)
  vpc_id = aws_vpc.vpc-prod.id
  cidr_block = var.pub_subnet_cidr[count.index]
  availability_zone = var.subnet_ids[count.index]
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  count = length(var.subnet_ids)
  vpc_id = aws_vpc.vpc-prod.id
  cidr_block = var.pri_subnet_cidr[count.index]
  availability_zone = var.subnet_ids[count.index]
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "my-ig" {
  vpc_id = aws_vpc.vpc-prod.id
  tags = {
    Name = "my-ig"
  }
}

resource "aws_eip" "nat-gw-eip" {
  domain = "vpc"
  network_border_group = "ap-south-1"
  tags = {
    Name = "mt-ig-eip"
  }
}

resource "aws_nat_gateway" "my-nag-gw" {
    subnet_id = aws_subnet.public-subnet[0].id
    allocation_id = aws_eip.nat-gw-eip.id
    tags = {
      Name = "my-nat-gateway"
    }
}

resource "aws_default_route_table" "public-routes" {
  default_route_table_id = aws_vpc.vpc-prod.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-ig.id
  }
  tags = {
    Name = "my-public-route"
  }
}

resource "aws_route_table_association" "public-association" {
  count = 2
  subnet_id = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_vpc.vpc-prod.default_route_table_id
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc-prod.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nag-gw.id
  }
  tags = {
    Name = "my-private-route"
  }
}

resource "aws_security_group" "my-security-group" {
  name = "My-Security-Group"
  description = "Allow SSH Rule"
  vpc_id = aws_vpc.vpc-prod.id
  dynamic "ingress" {
    for_each = var.sgports
    iterator = port
    content {
      description = "My description"
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }
  egress {
     from_port = 0
     to_port = 0
     protocol = -1
     cidr_blocks = [ "0.0.0.0/0" ]
     ipv6_cidr_blocks = [ "::/0" ]
  }
  tags = {
    Name = "My-Security-Group"
  }
}


resource "aws_route_table_association" "private-association" {
  count = 2
  subnet_id = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_instance" "my-public-instance" {
  count = 1
  ami = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet[count.index].id
  key_name = "instance-key-prsnl-aws"
  security_groups = [ aws_security_group.my-security-group.id ]
  associate_public_ip_address = true
  tags = {
    Name = "Public-Instance-${count.index + 1}"
  }
}

resource "aws_instance" "my-private-instance" {
  count = 1
  ami = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-subnet[count.index].id
  key_name = "instance-key-prsnl-aws"
  security_groups = [ aws_security_group.my-security-group.id ]
  associate_public_ip_address = false
  tags = {
    Name = "Private-Instance-${count.index + 1}"
  }
}
resource "aws_security_group" "my-sg" {
  vpc_id = "vpc-006941a8f63e4828e"
  dynamic "ingress" {
    for_each = [22, 80, 8080]
    iterator = port
    content {
      description = "Added SSH"
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
    Name = "my-custom-ec2"
  }
}

resource "aws_instance" "ec2-instance" {
  ami = "ami-0e670eb768a5fc3d4"
  subnet_id = "subnet-0e827c970f219bcd9"
  key_name = "instance-key-prsnl-aws"
  vpc_security_group_ids = [ aws_security_group.my-sg.id ]
  instance_type = "t2.micro"
  tags = {
    Name = "myinstance1"
  }
}

resource "aws_instance" "ec2-instance-public" {
  ami = "ami-0e670eb768a5fc3d4"
  subnet_id = "subnet-011d41d69f9f5db3a"
  key_name = "instance-key-prsnl-aws"
  vpc_security_group_ids = [ aws_security_group.my-sg.id ]
  instance_type = "t2.micro"
  tags = {
    Name = "myinstance1public"
  }
}
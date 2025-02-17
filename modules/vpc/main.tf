resource "aws_vpc" "demo_vpc" {
  cidr_block       = "10.0.0.0/20"
 

  tags = {
    Name = "demo_vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "demo_subnet_public_1"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.4.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "demo_subnet_private_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.8.0/22"
  availability_zone = "us-east-1b"

  tags = {
    Name = "demo_subnet_public_2"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.12.0/22"
  availability_zone = "us-east-1b"

  tags = {
    Name = "demo_subnet_private_2"
  }
}

resource "aws_internet_gateway" "demo_gw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo_igw"
  }
}



resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "10.0.0.0/20"
    gateway_id = "local"
  }


  tags = {
    Name = "demo_rt_private_1"
  }
}


resource "aws_route_table_association" "private_rt_as_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "10.0.0.0/20"
    gateway_id = "local"
  }


  tags = {
    Name = "demo_rt_private_1"
  }
}

resource "aws_route_table_association" "private_rt_as_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_gw.id
  }
 route {
    cidr_block = "10.0.0.0/20"
    gateway_id = "local"
  }

  tags = {
    Name = "demo_rt_public"
  }
}

resource "aws_route_table_association" "public_rt_as_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_as_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "demo_sg" {
  name = "demo_sg"
  vpc_id = aws_vpc.demo_vpc.id

 

  tags = {
    Name = "demo_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "demo_sg_egress" {
  security_group_id = aws_security_group.demo_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  ip_protocol = "-1"
  to_port     = 0 
  }

  resource "aws_vpc_security_group_ingress_rule" "demo_sg_ingress" {
  security_group_id = aws_security_group.demo_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "ssh"
  to_port     = 22 
  }
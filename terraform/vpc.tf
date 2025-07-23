
 resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "TF1-vpc"
    }
}

resource "aws_subnet" "main-subnet1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "TF1-subnet1"
    }
}

resource "aws_subnet" "main-subnet2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "ap-south-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "TF1-subnet2"
    }
}

resource "aws_internet_gateway" "main-igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "TF1-igw"
    }
}

resource "aws_security_group" "ssh-sg" {
    name        = "TF1-ssh-sg"
    description = "Allow SSH from my IP"
    vpc_id      = aws_vpc.main.id

    ingress {
        description      = "SSH from my IP"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["85.130.253.122/32"]
    }

    ingress {
        description      = "Allow all traffic from anywhere"
        from_port        = 3000
        to_port          = 3000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "TF1-ssh-sg"
    }
}

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elb-sg"
  }
}

resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "TF1-route-table"
  }
}

resource "aws_route_table_association" "subnet1-assoc" {
  subnet_id      = aws_subnet.main-subnet1.id
  route_table_id = aws_route_table.main-rt.id
}

resource "aws_route_table_association" "subnet2-assoc" {
  subnet_id      = aws_subnet.main-subnet2.id
  route_table_id = aws_route_table.main-rt.id
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "main-vpc" }
}

resource "aws_subnet" "sn1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "sn1" }
}

resource "aws_subnet" "sn2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "sn2" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "rtable" }
}

resource "aws_route_table_association" "r_assoc_sn1" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.rtable.id
}

# Attempt to find a recent Ubuntu 24 AMI published by Canonical. If not found, you may pass ami_id via variables.
data "aws_ami" "ubuntu24" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu-24.04*", "ubuntu/images/hvm-ssd/ubuntu-24.04*", "ubuntu-24*"]
  }
}

resource "aws_security_group" "ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "allow_ssh" }
}

resource "aws_instance" "ubuntu" {
  ami                    = length(trim(var.ami_id)) > 0 ? var.ami_id : data.aws_ami.ubuntu24.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.sn1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = { Name = "ubuntu-24-instance" }
}

# main.tf

# Define the AWS provider and set the region to Hyderabad (ap-south-1)
provider "aws" {
  region = "ap-south-1"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create two subnets in the VPC
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
}

# Create a security group for the EC2 instance
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance in one of the subnets
resource "aws_instance" "my_instance" {
  ami             = "ami-0a303ebf909b46aea" # Use the appropriate Ubuntu 22.04 AMI ID
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet1.id
  key_name        = "vinay"          # Replace with your key pair name
  security_groups  = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyEC2Instance"
  }
}


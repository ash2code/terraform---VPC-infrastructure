# terraform---VPC-infrastructure
terraform - VPC  infrastructure

############ Create VPC ##################
resource "aws_vpc" "tf-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

########### Create Public Subnet ################
resource "aws_subnet" "tf-public-subnet" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "tf-public-subnet"
  }
}

############### create Internet Gateway #######################
resource "aws_internet_gateway" "tf-public-subnet-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-public-subnet-igw"
  }
}

############## create route table #############################
resource "aws_route_table" "tf-route-table" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-route-table"
  }

################# Route Table association ###################
resource "aws_route_table_association" "tf-public-subnet-association" {
  subnet_id      = aws_subnet.tf-public-subnet.id
  route_table_id = aws_route_table.tf-route-table.id
}

################### AWS Route to IGW #######################
resource "aws_route" "tf-route-igw" {
  route_table_id            = aws_route_table.tf-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.tf-public-subnet-igw.id
}

#################### Create NACL ##########################
resource "aws_network_acl" "tf-nacl" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
   Name = "tf-nacl"
}
}

################### Create NACL Subnet Associations ###########
resource "aws_network_acl_association" "tf-nacl-subnet-association" {
  network_acl_id = aws_network_acl.tf-nacl.id
  subnet_id      = aws_subnet.tf-public-subnet.id
}

##################### Edit Inbound & Outbound Rules ###########
resource "aws_network_acl_rule" "tf-inbound-rule" {
  network_acl_id = aws_network_acl.tf-nacl.id
  rule_number    = 200
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "tf-outbound-rule" {
  network_acl_id = aws_network_acl.tf-nacl.id
  rule_number    = 200
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

##################### Create Storage Groups ####################
resource "aws_security_group" "tf-aws-sg" {
  name        = "tf-aws-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tf-aws-sg"
  }
}

####################### Create EC2 instance ############################
resource "aws_instance" "tf-web-server" {
  ami           = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.tf-public-subnet.id
  security_groups = [aws_security_group.tf-aws-sg.id]
  key_name        = "aws-vpc-key"
  user_data       = file("webapp.sh")
  tags = {
    Name = "tf-web-server"
}
}




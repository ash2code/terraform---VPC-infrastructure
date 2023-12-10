provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAXPL7YFM2VBOWPBVQ"
  secret_key = "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"
}

##############################################################
resource "aws_instance" "terraform-ec2" {
  ami           = "ami-0a7cf821b91bcccbc"
  instance_type = var.instance_type
  key_name      = "aws-vpc-key"

  tags = {
    Name = "terraform-ec2"
  }
}

variable "instance_type" {
  description = "Instance type t2.micro"
  type        = string
  default     = "t2.micro"
}

###########################################################
resource "aws_instance" "tf-ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "aws-vpc-key"

  tags = {
    Name = "tf-ec2"
  }
}
variable "ami_id" {
  description = "ami id is ami-0a7cf821b91bcccbc "
  type        = string
  default     = "ami-0a7cf821b91bcccbc"
}
############################################################
resource "aws_instance" "ec2_example" {

  ami           = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.micro"
  count         = var.instance_count

  tags = {
    Name = "Terraform EC2"
  }
}

variable "instance_count" {
  description = "instance count is 2"
  type        = number
  default     = 2
}


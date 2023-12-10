resource "aws_instance" "ec2_example" {
  ami                         = "ami-0a7cf821b91bcccbc"
  instance_type               = "t2.micro"
  count                       = 1
  associate_public_ip_address = var.enable_public_ip

  tags = {
    Name = "TF EC2"
  }
}

variable "enable_public_ip" {
  description = "hello india"
  type        = bool
  default     = false
}


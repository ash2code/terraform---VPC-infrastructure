
resource "aws_instance" "ec2-instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.assign_ip
  tags = {
    Name = "tf-example"
  }
}

variable "ami_id" {
  description = "simple terraform variable"
  type        = string
  default     = "ami-0a7cf821b91bcccbc"
}


variable "instance_type" {
  description = "instance type is t3.micro"
  type        = string
  default     = "t2.micro"
}

variable "assign_ip" {
  description = "assign public ip"
  type        = bool
  default     = true
}





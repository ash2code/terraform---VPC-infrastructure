resource "aws_instance" "tf-list" {
  ami           = "ami-0a7cf821b91bcccbc"
  count         = length(var.instance_types)
  instance_type = element(var.instance_types, count.index)

  tags = {
    Name = "tf-list-${count.index + 1}"
  }
}

variable "instance_types" {
  description = "list example"
  type        = list(string)
  default     = ["t2.micro", "t3.micro", "t3.small"]
}


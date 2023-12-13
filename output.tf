resource "aws_instance" "example" {
  ami           = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.micro"
  tags = {
   name = "example-ec2"
} 
}

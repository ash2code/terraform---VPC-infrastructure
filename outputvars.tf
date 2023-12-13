output "public_ip" {
 value = aws_instance.example.public_ip
}

output "private_ip" {
 value = aws_instance.example.private_ip
} 

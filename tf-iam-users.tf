resource "aws_iam_user" "tf-list-users" {
  count = length(var.users_names)
  name  = var.users_names[count.index]
  tags = {
    Name = "user-${count.index + 1}"
  }
}

variable "users_names" {
  description = "create IAM users"
  type        = list(string)
  default     = ["A1", "A2", "A3"]
}

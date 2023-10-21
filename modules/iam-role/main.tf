resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.services
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role" {
  count = length(var.role_policy_arns)
  role = aws_iam_role.role.name
  policy_arn = element(var.role_policy_arns, count.index)
}
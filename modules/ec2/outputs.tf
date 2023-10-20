###################
#       EC2       #
###################

output "private_ip" {
  value = aws_instance.instance.private_ip
}
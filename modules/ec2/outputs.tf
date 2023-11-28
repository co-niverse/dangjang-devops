###################
#       EC2       #
###################

output "private_ip" {
  value = aws_instance.instance.private_ip
}

output "network_interface_id" {
  value = aws_instance.instance.primary_network_interface_id
}
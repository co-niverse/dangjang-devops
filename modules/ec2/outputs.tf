###################
#       EC2       #
###################

output "mongo_primary_private_ip" {
  value = length(aws_instance.mongo.*.private_ip) > 1 ? aws_instance.mongo[2].private_ip : aws_instance.mongo[0].private_ip
}
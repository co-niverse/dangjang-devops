### Common
availability_zones = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
aws_region         = "ap-northeast-2"
env                = "prod"

### VPC
cidr_numeral       = "0"
cidr_numeral_public = {
  "0" = "0"
  "1" = "16"
  "2" = "32"
}
cidr_numeral_private = {
  "0" = "48"
  "1" = "64"
  "2" = "80"
}
cidr_numeral_private_db = {
  "0" = "96"
  "1" = "112"
  "2" = "128"
}

### Route53
domain = "dangjangclub.com"

### ECS
desired_count = 3
container_cpu = 2048
container_memory = 4096

### Kinesis
shard_count = 3
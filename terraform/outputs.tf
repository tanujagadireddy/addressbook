# output "public-ip"{
#   value =  aws_instance.myserver.public_ip
# }

output "public-ip"{
   value = module.myserver-ec2.ec2-ip.public_ip
}
output "private-ip"{
  value =  module.myserver-ec2.ec2-ip.private_ip
}

output "ami" {
  value=module.myserver-ec2.ec2-ip.ami
}

output "subnet_id" {
  value = module.myserver-subnet.subnet.id
}
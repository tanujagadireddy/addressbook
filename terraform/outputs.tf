output "instance-ip-0" {
  value = module.myec2.ec2.public_ip

}

output "subnet-id" {
  value = module.mysubnet.subnet.id
}

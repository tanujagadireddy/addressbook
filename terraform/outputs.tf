output "ec2_public_ip" {
    value = module.myown-webserver.ip.public_ip
}
output "aws_ami_id"{
    value = module.myown-webserver.ip.ami
}
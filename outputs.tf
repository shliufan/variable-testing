output "ec2_instance_virginia_public_ip" {
  value = aws_instance.ec2_instance_virginia.public_ip
}

output "ec2_instance_virginia_private_ip" {
  value = aws_instance.ec2_instance_virginia.private_ip
}

output "ec2_instance_singapore_public_ip" {
  value = aws_instance.ec2_instance_singapore.public_ip
}

output "ec2_instance_singapore_private_ip" {
  value = aws_instance.ec2_instance_singapore.private_ip
}




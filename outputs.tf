output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_sn1_id" {
  value = aws_subnet.sn1.id
}

output "subnet_sn2_id" {
  value = aws_subnet.sn2.id
}

output "instance_id" {
  value = aws_instance.ubuntu.id
}

output "instance_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

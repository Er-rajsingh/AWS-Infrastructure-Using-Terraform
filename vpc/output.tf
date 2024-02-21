output "Public_Instance_IP" {
  value = zipmap(aws_instance.my-public-instance[*].id, aws_instance.my-public-instance[*].public_ip)
}

output "Private_Instance_IP" {
  value = zipmap(aws_instance.my-private-instance[*].id, aws_instance.my-private-instance[*].private_ip)
}
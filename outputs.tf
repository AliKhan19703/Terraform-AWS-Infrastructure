output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "bucket_name" {
  value = var.bucket_name
}
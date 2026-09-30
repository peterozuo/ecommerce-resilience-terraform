output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.mysql.port
}

output "availability_zones" {
  description = "Availability Zones used by the project"
  value = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
}
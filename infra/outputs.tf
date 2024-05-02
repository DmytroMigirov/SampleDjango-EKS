 output "eks_cluster_name" {
    value = aws_eks_cluster.eks.name
}

output "region" {
  description = "AWS region"
  value       = var.region
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.django-vpc.id
}


output "rds_instance_address" {
  value = aws_db_instance.production.endpoint
}

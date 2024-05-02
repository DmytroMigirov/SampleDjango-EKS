#Creating EKS Cluster
  resource "aws_eks_cluster" "eks" {
    name     = "DjangoEKS"
    role_arn = aws_iam_role.master.arn

    vpc_config {
      subnet_ids = [aws_subnet.Mysubnet01.id, aws_subnet.Mysubnet02.id]
    }

    tags = {
      "Name" = "DjangoEKS"
    }

    depends_on = [
      aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
      aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
      aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    ]
  }

  resource "aws_instance" "kubectl-server" {
    ami                         = "ami-0c7217cdde317cfec"  # Replace with a valid AMI
    key_name                    = "prod-key"  # Make sure the key pair exists 
    instance_type               = "t2.medium"
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.Mysubnet01.id
    vpc_security_group_ids      = [aws_security_group.allow_tls.id]

    tags = {
      Name = "kubectl"
    }
  }

  resource "aws_eks_node_group" "node-grp" {
    cluster_name    = aws_eks_cluster.eks.name
    node_group_name = "eks-node-group"
    node_role_arn   = aws_iam_role.worker.arn   
    subnet_ids      = [aws_subnet.Mysubnet01.id, aws_subnet.Mysubnet02.id]
    capacity_type   = "ON_DEMAND"
    disk_size       = 10
    instance_types  = ["t2.medium"]

    remote_access {
      ec2_ssh_key               = "prod-key"
      source_security_group_ids = [aws_security_group.allow_tls.id]
    }

    labels = {
      env = "dev"
    }

    scaling_config {
      desired_size = 1
      max_size     = 2
      min_size     = 1
    }

    update_config {
      max_unavailable = 1
    }

    depends_on = [
      aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
      aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
      aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
  }

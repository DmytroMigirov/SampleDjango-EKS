 #Adding security group
  resource "aws_security_group" "allow_tls" {
    name_prefix   = "allow_tls_"
    description   = "Allow TLS inbound traffic"
    vpc_id        = aws_vpc.django-vpc.id

    ingress {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

# RDS Security Group (traffic Fargate -> RDS)
  resource "aws_security_group" "rds" {
    name        = "rds-security-group"
    description = "Allows inbound access from Fargate only"
    vpc_id      = aws_vpc.django-vpc.id

    ingress {
      protocol        = "tcp"
      from_port       = "5432"
      to_port         = "5432"
      security_groups = [aws_security_group.allow_tls.id]
    }

    egress {
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

######################################

variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource."
  default = {
    "TerminationDate" = "Permanent",
    "Environment"     = "Development",
    "Team"            = "DevOps",
    "DeployedBy"      = "Terraform",
    "OwnerEmail"      = "dmytromigirov@gmail.com"
  }
}

variable "cluster_name" {
  description = "Prefix of the deployment."
  type        = string
  default     = "sample-django"
}

variable "db_password" {
  description = "Password for the RDS database instance."
  default     = "samplepassword123"
}

############# RDS ################ 

variable "rds_db_name" {
  description = "RDS database name"
  default     = "djangodb"
}
variable "rds_username" {
  description = "RDS database username"
  default     = "django_user"
}
variable "rds_password" {
  description = "RDS database password"
}
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}

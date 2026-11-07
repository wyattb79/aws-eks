data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "subnet_a_vpc" {
  id = aws_subnet.subnet_a.vpc_id
}

data "aws_iam_group" "eks_admins" {
  group_name = var.eks_admin_group
}

data "http" "my_public_ip" {
  url = "http://checkip.global.api.aws"
}


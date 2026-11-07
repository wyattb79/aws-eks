module "eks-cluster" {
  source = "./modules/eks_cluster"

  eks_keypair = var.eks_keypair
  k8s_version = var.k8s_version
  partition = var.partition
  karpenter_namespace = var.karpenter_namespace
  karpenter_chart_version = var.karpenter_chart_version
  vpc_id = var.vpc_id
  vpc_cidr = var.vpc_cidr
  eks_admin_group = var.eks_admin_group
  cluster_name = var.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint URL for the cluster API server"
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

provider "kubernetes" {
  host = module.eks-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = [ "eks", "get-token", "--cluster-name", var.cluster_name ]
    command = "aws"
  }
}

provider "helm" {
  kubernetes = {
    host = module.eks-cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks-cluster.cluster_certificate_authority_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = [ "eks", "get-token", "--region", data.aws_region.current.region, "--cluster-name", var.cluster_name ]
      command = "aws"
    }
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.argo_namespace
  }

  depends_on = [
    module.eks-cluster
  ]
}

resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = "7.3.11"
  namespace = kubernetes_namespace_v1.argocd.metadata[0].name
  create_namespace = true

  wait = true
  timeout = 600
  atomic = true

  values = [
    templatefile("${path.module}/argo-values.yml", {
      account_id = data.aws_caller_identity.current.account_id
    })
  ]
}

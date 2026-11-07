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
      args = [ "eks", "get-token", "--cluster-name", var.cluster_name ]
      command = "aws"
    }
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.argo_namespace
  }
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
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}

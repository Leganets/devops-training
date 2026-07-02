module "app" {                   # <- "экземпляр класса"
  source   = "../../modules/k8s-app"   # локальный путь (без version)
  env      = terraform.workspace
  replicas = terraform.workspace == "prod" ? 2 : 1
}

resource "kubernetes_namespace_v1" "legacy" {
  metadata {
    name = "manual-ns"          # имя ровно как у созданного руками
  }
}

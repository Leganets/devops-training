module "app" {                   # <- "экземпляр класса"
  source   = "../../modules/k8s-app"   # локальный путь (без version)
  env      = "prod"
  greeting = "prod-stale-lock"
  replicas = 2
}
moved {
  from = kubernetes_deployment_v1.web
  to = module.app.kubernetes_deployment_v1.web
}

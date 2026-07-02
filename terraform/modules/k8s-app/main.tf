terraform {
  required_providers {           # <- модуль ОБЪЯВЛЯЕТ потребность в провайдере...
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}
# ВНИМАНИЕ: блока "provider kubernetes" здесь НЕТ -> он наследуется из корня

locals {
  ns_name = "tf-${var.env}"      # -> DRY: tf-dev / tf-prod
}

resource "kubernetes_namespace_v1" "this" {
  metadata { name = local.ns_name }
}

resource "kubernetes_config_map_v1" "app" {
  metadata {
    name      = "app-config"
    namespace = kubernetes_namespace_v1.this.metadata[0].name   # metadata[0] - вложенный блок = список (L50, #20)
  }
  data = { GREETING = var.greeting }
}

resource "kubernetes_deployment_v1" "web" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  spec {
    replicas = var.replicas      # <- параметр окружения
    selector { match_labels = { app = "web" } }
    template {
      metadata { labels = { app = "web" } }
      spec {
        container {
          name  = "nginx"
          image = "nginx:alpine"
          env_from {
            config_map_ref { name = kubernetes_config_map_v1.app.metadata[0].name }
          }
          resources {
            requests = { cpu = "25m",  memory = "32Mi" }
            limits   = { cpu = "100m", memory = "64Mi" }
          }
        }
      }
    }
}
    lifecycle { ignore_changes = [spec[0].replicas] }   # <- защита от HPA (L49/L50, #22)
}

resource "kubernetes_service_v1" "web" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  spec {
    selector = { app = "web" }
    port { 
      port = 80 
      target_port = 80 
	}
  }
}

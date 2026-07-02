output "deployment_uid" {        # -> отдаём наружу uid (пруф патча из L50)
  value = kubernetes_deployment_v1.web.metadata[0].uid
}
output "service_name" {
  value = kubernetes_service_v1.web.metadata[0].name
}

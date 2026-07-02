output "prod_deployment_uid" {
  value = module.app.deployment_uid # <- читаем выход дочернего модуля
}

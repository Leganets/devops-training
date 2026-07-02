variable "env" {
  type = string
}
variable "greeting" {
  type    = string
  default = "hello"
}
variable "replicas" {
  type    = number
  default = 1
}

variable "aws_region" {
  default = "us-east-1" 
}

variable "server_names" {
  type    = list(string)
  default = ["deployment", "ansible"]
}

variable "ingress" {
  description = "Accessible ports for the server"
  type        = list(number)
  default     = [22, 80, 443, 8080, 8081, 8087, 6379, 8082, 8083]

}

variable "egress" {
  description = "The SSH port to use for the server"
  type        = list(number)
  default     = [22, 80, 443, 8080, 8081, 8087, 6379, 8082, 8083]
}
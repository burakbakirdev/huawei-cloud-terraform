
variable "hw_access_key" {
  description = "Access Key"
  type        = string
}

variable "hw_secret_key" {
  description = "Secret Key"
  type        = string
}

variable "hw_region_name" {
  description = "Region Name"
  type        = string
}

variable "vpc_name" {
  default = "vpc-basic"
}
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}
variable "subnet_name" {
  default = "subent-basic"
}
variable "subnet_cidr" {
  default = "172.16.10.0/24"
}
variable "subnet_gateway" {
  default = "172.16.10.1"
}
variable "primary_dns" {
  default = "100.125.1.250"
}

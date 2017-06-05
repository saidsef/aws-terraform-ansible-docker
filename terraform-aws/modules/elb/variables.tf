// Module specific variables
variable "name" {}

variable "environment" {}
variable "availability_zones" {}
variable "subnets" {}
variable "security_groups" {}

variable "source_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  default     = "0.0.0.0/0"
}

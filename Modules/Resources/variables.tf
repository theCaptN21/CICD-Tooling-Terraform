# --- variables.tf ---

variable "private_cidrs" {
  type = string
  default = "10.0.1.0/24"
}

variable "public_cidrs" {
  type = string
  default = "10.0.101.0/24"
}

variable "vpc_cidr" {
  description = "CIDR block for new vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "availability_zones" {
  type = string
  default = "us-east-1a"
}
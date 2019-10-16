# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

variable "project_name" {
  type        = string
  description = "Name of the project that this environement belongs to"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM SSL Certificate ARN for public-facing ALB"
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC ID in which to place ECS cluster ALB"
}

variable "public_subnet" {
  type        = string
  description = "Public subnet ID from tf_vpc module"
}
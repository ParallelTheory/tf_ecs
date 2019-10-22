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

variable "private_subnets" {
  type        = list
  description = "List of Private subnet IDs from tf_vpc module, within which ECS instances will be placed"
}

variable "ecs_instance_type" {
  type        = string
  description = "AWS EC2 instance type for ECS cluster nodes; default: t3.large"
  default     = "t3.large"
}

variable "ecs_ami" {
  type        = string
  description = "AWS AMI ID for ECS cluster nodes"
  default     = "ami-..."
}

variable "ecs_root_size" {
  type        = string
  description = "Size of ECS instance root volume in GB; default: 100G"
  default     = 100
}

variable "ecs_key_pair_name" {
  type        = string
  description = "Name of AWS EC2 key pair for SSH authentication"
}

variable "ecs_min_size" {
  type        = string
  description = "Minimum number of ECS instances within the cluster; default: 1"
  default     = 1
}

variable "ecs_max_size" {
  type        = string
  description = "Maximum number of ECS instances within the cluster; default: 1"
  default     = 1
}

variable "ecs_desired_size" {
  type        = string
  description = "Preferred number of ECS instances within the cluster -- should be between ecs_min_size and ecs_max_size, inclusive; default: 1"
  default     = 1
}
ECS
===

Introduction
------------

This module creates an ECS cluster and a public-facing ALB within a specified VPC/subnet pair. It creates two ALB listeners, one which explicitly redirects HTTP traffic to HTTPS, and an HTTPS listener that forwards traffic to the ECS cluster.


Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_name | Name of associated project, for resource tagging | string | nil | yes |
| acm\_certificate\_arn | AWS ACM SSL certificate ARN for securing HTTPS traffic | string | nil | yes |
| vpc\_id | AWS VPC ID within which to place ALB | string | nil | yes |
| public\_subnet | Public-facing subnet within which to place listener endpoint | string | nil | yes |


Outputs
-------


Example
-------
```
provider "aws" {
  region  = "us-east-1"
  version = "~> 2.31.0"
}

module "aws_vpc" {
  source = "github.com/ParallelTheory/tf_vpc"

  project_name = "example_vpc"
  vpc_cidr     = "10.0.0.0/16"
  subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_az    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_cidr  = "10.0.254.0/28"

  peer_vpc_cidrs   = ["10.1.0.0/24"]
  peer_vpc_ids     = ["vpc-27cda542"]
  peer_vpc_regions = ["us-east-1"]
}

module "aws_ecs" {
  source = "github.com/ParallelTheory/tf_ecs"

  project_name  = "example_ecs"
  vpc_id        = "${module.aws_vpc.vpc_id}"
  public_subnet = "${module.aws_vpc.public_subnet_id}"
  acm_certificate_arn = "${aws_acm_certificate.example_acm_cert.arn}"
}

```


Authors
-------

_Copyright 2019 M. Holger / Parallel Theory LLC, All Rights Reserved_


License
-------

_TBD_
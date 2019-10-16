# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

resource "aws_iam_role" "ecs_service" {
  name               = "${var.project_name}-${terraform.workspace}-ecs-services"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service.json}"
}

resource "aws_iam_role" "ecs_instance" {
  name               = "${var.project_name}-${terraform.workspace}-ecs-instances"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance.json}"
}

resource "aws_iam_policy_attachment" "ecs_service_policy" {
  name       = "${var.project_name}-${terraform.workspace}-ecs_service}"
  roles      = ["${aws_iam_role.ecs_service.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_policy_attachment" "ecs_instance_policy" {
  name       = "${var.project_name}-${terraform.workspace}-ecs_instance"
  roles      = ["${aws_iam_role.ecs_instance.name}"]
  policy_arn = "arn:aws:iam::policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.project_name}-${terraform.workspace}-ecs-instance"
  path = "/"
  role = "${aws_iam_role.ecs_instance.id}"
}

data "aws_iam_policy_document" "ecs_service" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_instance" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
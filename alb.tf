# Copyright 2019 M.Holger / Parallel Theory LLC - All rights reserved

resource "aws_lb" "public_ecs" {
  name            = "${var.project_name}-${terraform.workspace}-alb"
  security_groups = ["${aws_security_group.ecs_public.id}"]
  subnets         = ["${var.public_subnet}"]

  tags = {
    Name      = "${var.project_name}-${terraform.workspace}-alb"
    Project   = var.project_name
    Workspace = terraform.workspace
  }
}

resource "aws_lb_target_group" "pubwebs" {
  name     = "${var.project_name}-${terraform.workspace}-pubwebs"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name      = "${var.project_name}-${terraform.workspace}-pubwebs"
    Project   = var.project_name
    Workspace = terraform.workspace
  }
}

resource "aws_lb_listener" "pubwebs_http" {
  load_balancer_arn = "${aws_lb.public_ecs.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "pubwebs_https" {
  load_balancer_arn = "${aws_lb.public_ecs.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.acm_certificate_arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.pubwebs.arn}"
  }
}

resource "aws_security_group" "ecs_public" {
  name        = "${var.project_name}-${terraform.workspace}-pubwebs-ingress"
  description = "Allow public HTTP/HTTPS traffic to ECS ALB"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
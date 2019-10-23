resource "aws_launch_configuration" "ecs_launch" {
  name                 = "${var.project_name}-${terraform.workspace}-ecs-launch-group"
  image_id             = "${var.ecs_ami}"
  instance_type        = "${var.ecs_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.id}"

  root_block_device {
    volume_type           = "standard"
    volume_size           = "${var.ecs_root_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${aws_security_group.ecs_public.id}"]
  associate_public_ip_address = false
  key_name                    = "${var.ecs_key_pair_name}"
  user_data                   = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.project_name}-${terraform.workspace} >> /etc/ecs/ecs.config
    EOF
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "${var.project_name}-${terraform.workspace}-asg"
  max_size             = "${var.ecs_max_size}"
  min_size             = "${var.ecs_min_size}"
  desired_capacity     = "${var.ecs_desired_size}"
  vpc_zone_identifier  = var.private_subnets
  launch_configuration = "${aws_launch_configuration.ecs_launch.name}"
  health_check_type    = "ELB"
}
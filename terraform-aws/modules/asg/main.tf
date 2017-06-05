resource "aws_launch_configuration" "lconf" {
  name_prefix     = "${var.name}-${var.environment}-asg"
  image_id        = "ami-ed82e39e"
  key_name        = "${var.key_name}"
  instance_type   = "${var.instance_type}"
  user_data       = "${file("userdata.sh")}"
  security_groups = ["${split(",", var.security_groups)}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  availability_zones        = ["eu-west-1a", "eu-west-1b"]
  name                      = "${var.name}-${var.environment}-asg"
  max_size                  = "${var.count}"
  min_size                  = "${var.count}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = "${var.count}"
  force_delete              = true
  vpc_zone_identifier       = ["${split(",", var.vpc_zone_identifier)}"]
  load_balancers            = ["${split(",", var.load_balancers)}"]
  launch_configuration      = "${aws_launch_configuration.lconf.name}"

  tag {
    key                 = "Name"
    value               = "${var.name}-${var.environment}-asg"
    propagate_at_launch = true
  }
}

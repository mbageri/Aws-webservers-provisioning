data "aws_availability_zones" "all" {}

module "my-security_groups" {
  source = "git::https://github.com/mbageri/Aws-Securitygroups"
}

resource "aws_launch_configuration" "example" {
  image_id		    = var.AMI_ID
  instance_type   = var.INSTANCE_TYPE
  security_groups = ["${module.my-security_groups.aws_security_group.instance.id}"]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.SERVER_PORT}" &
              EOF
			  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names[0]}"]
  
  load_balancers       = ["${aws_elb.example.name}"]
  health_check_type    = "ELB"
  
  min_size = 2
  max_size = 10
  
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names[0]}"]
  security_groups    = ["${module.my-security_groups.aws_security_group.elb.id}"]
  
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.SERVER_PORT}"
    instance_protocol = "http"
  }
  
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.SERVER_PORT}/"
  }
}
#---------------------------------------------------------------------
# Scripts for ceation infrastructure with LBA and ASG (Amazon Servers)
# TF (c) AG 2021
# Main script.
# Create resources:
#   - Security group (ports: 80, 443, 22)
#   - Server will be launched in the default subnets
#   - Launch configuration for Amazon Linux (kernel 5.10) with nginx
#   - ELB
#   - Autoscaling group
#----------------------------------------------------------------------

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}



# AMI for Amazon Linux (kernel v 5.10)
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

resource "aws_default_subnet" "def_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "def_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}



resource "aws_security_group" "sg_ter01" {
  name        = "sg_ter01_def"
  description = "SG for web server from terrafom"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg_ter_def"
    Owner = var.pr_owner
  }
}


resource "aws_launch_configuration" "web_ter" {
  name_prefix     = "Web-server-HA-LC-"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.inst_type
  security_groups = [aws_security_group.sg_ter01.id]
  user_data       = file(var.usr_dt_src_file)
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_elb" "web_elb_ter" {
  name               = "Web-server-HA-ELB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.sg_ter01.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name  = "elb_ter_def"
    Owner = var.pr_owner
  }
}



resource "aws_autoscaling_group" "web_asg_ter" {
  name                 = "ASG-${aws_launch_configuration.web_ter.name}"
  launch_configuration = aws_launch_configuration.web_ter.name
  min_size             = var.maxsize
  max_size             = var.minsize
  min_elb_capacity     = var.elbcap
  vpc_zone_identifier  = [aws_default_subnet.def_az1.id, aws_default_subnet.def_az2.id, ]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web_elb_ter.name]

  dynamic "tag" {
    for_each = {
      Name   = "webserver_in_asg_ter_def"
      Owner  = var.pr_owner
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

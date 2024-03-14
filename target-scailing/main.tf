resource "aws_ami_from_instance" "myweb-ami" {
  name = "myweb-ami-tf"
  source_instance_id = var.instance-id
  snapshot_without_reboot = true
  tags = {
    Name = "Instance-backup-tf"
  }
}

resource "aws_security_group" "my-asg-instance-sg" {
  name = "my-asg-sg"
  description = "used in asg"
  vpc_id = var.aws-vpc
  dynamic "ingress" {
    for_each = var.sg-ports
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name = "vpc-id"
    values = [ var.aws-vpc ]
  }
}

data "aws_subnet" "subnet_values" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id = each.value
}

resource "aws_launch_template" "my-target-asg-lt-tf" {
    description = "Template used for asg"
    name = "target-asg-web-template"
    instance_type = "t2.micro"
    image_id = aws_ami_from_instance.myweb-ami.id
    key_name = "instance-key-prsnl-aws"
    vpc_security_group_ids = [ aws_security_group.my-asg-instance-sg.id ]
    tags = {
      Name = "my-web-asg-template"
    }
}

resource "aws_autoscaling_group" "target-asg-tf" {
  name = "my-web-asg-tf"
  desired_capacity = 1
  min_size = 1
  max_size = 5
  launch_template {
    id = aws_launch_template.my-target-asg-lt-tf.id
    version = aws_launch_template.my-target-asg-lt-tf.latest_version
  }
  default_instance_warmup = 60
  default_cooldown = 300
  vpc_zone_identifier = [ for s in data.aws_subnet.subnet_values: s.id ]
  enabled_metrics = [ "GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "WarmPoolMinSize" ]
  tag {
    propagate_at_launch = true
    key = "Name"
    value = "My-asg-instance"
  }
  
}

resource "aws_autoscaling_policy" "dynamic-asg-policy" {
  name = "target-scailing-policy"
  autoscaling_group_name = aws_autoscaling_group.target-asg-tf.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value = 60
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}
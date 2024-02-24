resource "aws_cloudwatch_metric_alarm" "step-up-alarm" {
  alarm_name = "step-up-asg-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  period = 300
  statistic = "Average"
  namespace = "AWS/EC2"
  threshold = 60
  insufficient_data_actions = []
  treat_missing_data = "missing"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my-web-asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "step-down-alarm" {
  alarm_name = "step-down-asg-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  period = 300
  statistic = "Average"
  namespace = "AWS/EC2"
  threshold = 60
  insufficient_data_actions = []
  treat_missing_data = "missing"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my-web-asg.name
  }
}
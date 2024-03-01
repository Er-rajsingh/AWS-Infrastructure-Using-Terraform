resource "aws_cloudwatch_metric_alarm" "step-up-alarm" {
  alarm_name = "step-up-asg-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 3
  metric_name = "CPUUtilization"
  period = 300
  statistic = "Average"
  namespace = "AWS/AutoScaling"
  threshold = 60
  insufficient_data_actions = []
  treat_missing_data = "missing"
  unit = "Percent"
  alarm_actions = [ aws_autoscaling_policy.asg-scale-up.arn ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my-web-asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "step-down-alarm" {
  alarm_name = "step-down-asg-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 3
  metric_name = "CPUUtilization"
  period = 300
  statistic = "Average"
  namespace = "AWS/AutoScaling"
  threshold = 60
  unit = "Percent"
  insufficient_data_actions = []
  treat_missing_data = "missing"
  alarm_actions = [ aws_autoscaling_policy.asg-scale-down.arn ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my-web-asg.name
  }
}
variable "aws-vpc" {
  type = string
  default = "vpc-006941a8f63e4828e"
}

variable "instance-id" {
  type = string
  default = "i-09535ad54d0198dea"
}

variable "sg-ports" {
  type = list(number)
  default = [ 22, 80 ]
}
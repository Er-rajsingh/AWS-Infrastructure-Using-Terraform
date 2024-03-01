variable "aws-vpc" {
  type = string
  default = "vpc-006941a8f63e4828e"
}

variable "instance-id" {
  type = string
  default = "i-0b99359d225cb6bff"
}

variable "sg-ports" {
  type = list(number)
  default = [ 22, 80 ]
}
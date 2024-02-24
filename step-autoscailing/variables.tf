variable "aws-vpc" {
  type = string
  default = "vpc-006941a8f63e4828e"
}

variable "instance-id" {
  type = string
  default = "i-0b620a95e2b125e5d"
}

variable "sg-ports" {
  type = list(number)
  default = [ 22, 80 ]
}
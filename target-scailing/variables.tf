variable "aws-vpc" {
  type = string
  default = "vpc-006941a8f63e4828e"
}

variable "instance-id" {
  type = string
  default = "i-059d4c02946d335b2"
}

variable "sg-ports" {
  type = list(number)
  default = [ 22, 80 ]
}
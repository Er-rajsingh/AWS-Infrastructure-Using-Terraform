variable "subnet_ids" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "pub_subnet_cidr" {
    type = list(string)
    default = ["10.70.10.0/24", "10.70.20.0/24"]
}

variable "pri_subnet_cidr" {
    type = list(string)
    default = ["10.70.30.0/24", "10.70.40.0/24"]
}

variable "sgports" {
  type = list(number)
  default = [22, 80]
}
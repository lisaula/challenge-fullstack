variable "aws-region" {
    type = string 
    default = "us-east-1"
  
}

variable "bucket" {
  type = map(any)
}
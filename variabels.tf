variable "ACCESS_KEY" {
  type    = string
  default = ""
}

variable "SECRET_KEY" {
  type    = string
  default = ""
}

variable "REGION" {
  type    = string
  default = "eu-north-1"
}

variable "AMI_ID" {
  type    = string
  default = "ami-0989fb15ce71ba39e"

}

variable "INSTANCE_TYPE" {
  type    = string
  default = "t3.micro"

}

variable "KEY_NAME" {
  type    = string
  default = ""

}

variable "SERVER_PORT" {
  description = "The port the server will use for HTTP requests"
  default = "8080"
}
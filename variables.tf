variable "ami_id" {
  description = "Optional: explicit AMI id to use for the Ubuntu instance. If empty, a recent Ubuntu 24 AMI is looked up automatically."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

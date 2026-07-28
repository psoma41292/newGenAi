variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}

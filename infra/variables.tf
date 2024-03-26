#Define AWS Region
variable "region" {
  description = "Infrastructure region."
  type        = string
  default     = "us-east-2"
}
#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user."
  type        = string
  sensitive   = true
  default     = ""
}
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user."
  type        = string
  sensitive   = true
  default     = ""
}
variable "name" {
  description = "The name of the application."
  type        = string
  default     = "app-4"
}
variable "vpc_cidr" {
  description = "The CIDR of the VPC."
  type        = string
  default     = "11.90.30.0/25"
}
variable "subnet_cidr_public" {
  description = "The CIDR blocks for the public subnets."
  type        = list(any)
  default     = ["11.90.30.0/27", "11.90.30.32/27", "11.90.30.64/27"]
}
variable "availability_zone" {
  description = "The availability zones for teh public subnets."
  type        = list(any)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
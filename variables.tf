#---------------------------------------------------------------------
# Scripts for ceation infrastructure with LBA and ASG (Amazon Servers)
# TF (c) AG 2021
# Variables definition
#----------------------------------------------------------------------

variable "region" {
  description = "Please enter needed region."
  default     = "eu-central-1"
}

variable "pr_owner" {
  default = "Ownrer_of_project"
}

variable "inst_type" {
  description = "Please enter instance type."
  default     = "t2.micro"
}

variable "key_name" {
  description = "Please enter key file name."
  default     = "ga-frank"
}

variable "usr_dt_src_file" {
  description = "Please enter file name for user data source."
  default     = "user_data.sh"
}


variable "allow_ports" {
  description = "Please enter allowing ports for security group."
  type        = list(any)
  default     = ["80", "443", "22"]
}



variable "maxsize" {
  default = 2
}

variable "minsize" {
  default = 2
}

variable "elbcap" {
  default = 2
}

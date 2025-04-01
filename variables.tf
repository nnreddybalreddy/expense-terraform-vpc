
variable "project_name" {
  type=string 
}

variable "environment" {
  default = "dev"
}


variable "vpc_cidr" {
  type=string 
}

variable "common_tags" {
  default = {

  }
}


variable "enable_dns_hostnames" {
  default = true 
}

variable "vpc_tags" {
  default = {

  }
}

variable "igw_tags" {
  default = {
    
  }
}



variable "public_subnet_cidrs" {
  type=list

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Please enter two valid subnet cidrs"
  }
}

variable "private_subnet_cidrs" {
  type=list

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Please enter two valid private subnet cidrs"
  }
}

variable "database_subnet_cidrs" {
  type=list

  validation {
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "Please enter two valid subnet cidrs"
  }
}



variable "nat_gateway_tags" {
  default = {

  }
}



variable "public_route_table_tags" {
  default = {

  }
}

variable "private_route_table_tags" {
  default = {

  }
}

variable "database_route_table_tags" {
  default = {

  }
}

#peering
variable"is_peering_required"{
  # default = false
}

variable"acceptor_vpc_id"{
  type=string
  default=""
}

variable"vpc_peering_tags"{
  default={}
}



variable "database_subnet_group_tags" {
  default = {

  }
}







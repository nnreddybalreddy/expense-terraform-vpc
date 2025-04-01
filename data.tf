# data "aws_availability_zones" "selected" {
#   filter {
#     name = "zone-id"
#     values = ["us-east-1a", "us-east-1b"]
#   }
# }

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
} 


data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}

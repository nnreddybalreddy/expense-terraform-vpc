output "selected_availability_zones" {
  value = data.aws_availability_zones.selected.zone_ids
}

output "azs" {
    value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output"public_subnet_ids"{
  value=aws_subnet.public[*].id  
}

output"private_subnet_ids"{
  value=aws_subnet.private[*].id
}


output"database_subnet_ids"{
  value=aws_subnet.database[*].id
}

output"db_subnet_group_id"{
  value=aws_db_subnet_group.default.id
}




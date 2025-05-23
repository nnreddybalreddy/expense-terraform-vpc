resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames 

  tags=merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name=local.resource_name
    }
  )

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id 

  tags=merge(
    var.common_tags,
    var.igw_tags,
    {
        Name=local.resource_name
    }
  )

}


resource "aws_subnet" "public" {
  count=length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id 
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  # availability_zone = data.aws_availability_zones.selected.names[count.index]
  availability_zone = local.az_names[count.index]
  

    tags=merge(
    var.common_tags,
    var.igw_tags,
    {
        Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )


}


resource "aws_subnet" "private" {
  count=length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id 
  cidr_block = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  # availability_zone = data.aws_availability_zones.selected.names[count.index]
  availability_zone = local.az_names[count.index]
  

    tags=merge(
    var.common_tags,
    var.igw_tags,
    {
        Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )


}


resource "aws_subnet" "database" {
  count=length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.main.id 
  cidr_block = var.database_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  # availability_zone = data.aws_availability_zones.selected.names[count.index]
  availability_zone = local.az_names[count.index]
  

    tags=merge(
    var.common_tags,
    var.igw_tags,
    {
        Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )


}

resource"aws_eip""nat"{
  domain  ="vpc"
}


resource"aws_nat_gateway""nat"{
  allocation_id=aws_eip.nat.id
  subnet_id    =aws_subnet.public[0].id


  tags=merge(var.common_tags,
                var.nat_gateway_tags,
                {
                  Name=local.resource_name #expense-dev
                }
  )


  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on=[aws_internet_gateway.igw]
}

resource"aws_route_table""public"{
  vpc_id=aws_vpc.main.id


  tags=merge(var.common_tags, 
               var.public_route_table_tags,
               {
                Name="${local.resource_name}-public" #expense-dev
               }
  )
}


resource"aws_route_table""private"{
  vpc_id=aws_vpc.main.id


  tags=merge(var.common_tags, 
               var.private_route_table_tags,
               {
                Name="${local.resource_name}-private" #expense-dev
               }
  )
}


resource"aws_route_table""database"{
  vpc_id=aws_vpc.main.id


  tags=merge(var.common_tags, 
               var.database_route_table_tags,
               {
                Name="${local.resource_name}-database" #expense-dev
               }
  )
}

resource"aws_route""public_route"{
  route_table_id           =aws_route_table.public.id
  destination_cidr_block="0.0.0.0/0"
  gateway_id=aws_internet_gateway.igw.id
}


resource"aws_route""private_route"{
  route_table_id           =aws_route_table.private.id
  destination_cidr_block="0.0.0.0/0"
  nat_gateway_id=aws_nat_gateway.nat.id
}


resource"aws_route""database_route"{
  route_table_id           =aws_route_table.database.id
  destination_cidr_block="0.0.0.0/0"
  nat_gateway_id=aws_nat_gateway.nat.id
}

resource"aws_route_table_association""public"{
  count=length(var.public_subnet_cidrs)
  subnet_id     = element(aws_subnet.public[*].id,count.index)

  route_table_id=aws_route_table.public.id
}


resource"aws_route_table_association""private"{
  count=length(var.private_subnet_cidrs)
  subnet_id     =element(aws_subnet.private[*].id,count.index)
  route_table_id=aws_route_table.private.id
}


resource"aws_route_table_association""database"{
  count=length(var.database_subnet_cidrs)
  subnet_id     =element(aws_subnet.database[*].id,count.index)
  route_table_id=aws_route_table.database.id
}


resource"aws_db_subnet_group""default"{
  name      ="${local.resource_name}"
  subnet_ids=aws_subnet.database[*].id


  tags=merge(
    var.common_tags,
    var.database_subnet_group_tags,
    {
        Name="${local.resource_name}"
    }
  )
}





















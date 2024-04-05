#author-----AjayKumarReddy
#Date------16\03\2024
#Resource Configuration
# Ec-2 Creation
resource "aws_instance" "terraform" {
  ami                     = var.ami-id
  instance_type           = var.instance-type
  subnet_id = aws_subnet.MySN.id
  vpc_security_group_ids = [aws_security_group.Terraform_SG.id]

}
# VPC Creation 
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  tags = {
   name = "Terraform_Vpc"
  }
}
#InterNetGateWay
  resource "aws_internet_gateway" "myIgw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      "key" = "TerraformIgw"
    }

}
#Subnet
resource "aws_subnet" "MySN" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet-cidr
  availability_zone = var.availability-zone
  map_public_ip_on_launch = true
  tags = {
    "key" = "Terraform_publicsubnet"
  }
}
# Route-table
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.route-cidr
    gateway_id = aws_internet_gateway.myIgw.id
  }
}
#Routetable-association 
resource "aws_route_table_association" "PublicRT" {
  subnet_id      = aws_subnet.MySN.id
  route_table_id = aws_route_table.PublicRT.id 
}
#SecurityGroup
resource "aws_security_group" "Terraform_SG" {
  name        = "Terraform_SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "Terraform_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Terraform-inbound" {
  security_group_id = aws_security_group.Terraform_SG.id
  cidr_ipv4         = aws_vpc.myvpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "Terraform-outbound" {
  security_group_id = aws_security_group.Terraform_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}















  

   




  




    
    
  

 

  


  









  
     
  
   
  


# --- autoscaling/main.tf ---

resource "aws_vpc" "finalvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "finalvpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.finalvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.finalvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public2"
  }
}

resource "aws_internet_gateway" "final-gw" {
  vpc_id = aws_vpc.finalvpc.id

  tags = {
    Name = "final-gw"
  }
}

resource "aws_route_table" "final-rt" {
  vpc_id = aws_vpc.finalvpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.final-gw.id
  }

  tags = {
    Name = "final-rt"
  }
}


resource "aws_route_table_association" "rta-public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.final-rt.id
}

resource "aws_route_table_association" "rta-public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.final-rt.id
}

resource "aws_launch_template" "final_lt" {
  name_prefix   = "final-lt"
  image_id      = "ami-0cabc39acf991f4f1"
  instance_type = "t3.micro"
}

resource "aws_autoscaling_group" "final_asg" {
     availability_zones = ["us-east-1a"]
     desired_capacity = 3
     max_size = 3
     min_size = 2

     launch_template {
       id = aws_launch_template.final_lt.id

     }
}
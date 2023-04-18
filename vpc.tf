resource "aws_vpc" "Wp_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Wp_vpc"
  }
}

resource "aws_internet_gateway" "Wp_internet_gateway" {
  vpc_id = aws_vpc.Wp_vpc.id
  tags = {
    "Name" = "Wp_Internet_Gateway"
  }
}


resource "aws_route_table" "Wp_Route_table" {
  vpc_id = aws_vpc.Wp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Wp_internet_gateway.id
  }
  tags = {
    Name = "Wp_Route_table"
  }
}

resource "aws_subnet" "Wp_subnet_1" {
  vpc_id = aws_vpc.Wp_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    "Name" = "Wp_subnet_1"
  }
}
resource "aws_subnet" "Wp_subnet_2" {
  vpc_id = aws_vpc.Wp_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    "Name" = "Wp_subnet_2"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.Wp_subnet_1.id
  route_table_id = aws_route_table.Wp_Route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id = aws_subnet.Wp_subnet_2.id
  route_table_id = aws_route_table.Wp_Route_table.id
}

resource "aws_security_group" "Allow_web" {
  name = "Allow_web_traffic"
  description = "Allow web traffic"
  vpc_id = aws_vpc.Wp_vpc.id
  ingress =  [{
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Access to HTTPS"
    from_port = 443
    protocol = "tcp"
    to_port = 443
    prefix_list_ids = []
    security_groups = []
    self = false
  }, 
  {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description = "Access to HTTP"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    prefix_list_ids = []
    security_groups = []
    self = false
  }
  ]
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = ["::/0"]
    from_port = 0
    protocol = "-1"
    to_port = 0
    prefix_list_ids = []
    security_groups = []
    self = false
    description = "Egress"
  } ]
  tags = {
    "Name" = "Allow_Web"
  }
}
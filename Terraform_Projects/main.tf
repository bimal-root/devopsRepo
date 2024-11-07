resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr 
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "ap-southeast-2a"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
  
}
resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "ap-southeast-2b"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
  
}
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_security_group" "secgrp" {
  name        = "web-sg"
  vpc_id      = aws_vpc.myvpc.id

}

resource "aws_vpc_security_group_ingress_rule" "sg-ingress1" {
  description = "HTTP from VPC"
  security_group_id = aws_security_group.secgrp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "sg-ingress2" {
  description = "SSH"
  security_group_id = aws_security_group.secgrp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_egress_rule" "sg-egress1" {
    security_group_id = aws_security_group.secgrp.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
  
}
resource "aws_instance" "server1" {
    ami = "ami-001f2488b35ca8aad"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.secgrp.id]
    subnet_id = aws_subnet.sub1.id
    user_data = base64encode(file("userdata.sh"))
  
}
resource "aws_instance" "server2" {
    ami = "ami-001f2488b35ca8aad"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.secgrp.id]
    subnet_id = aws_subnet.sub2.id
    user_data = base64encode(file("userdata1.sh"))
}
resource "aws_lb" "myalb" {
    name = "appLB"
    internal = "false"
    load_balancer_type = "application"
    security_groups = [aws_security_group.secgrp.id]
    subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]
    tags = {
        name = "web"
    }
}
resource "aws_lb_target_group" "tg" {
    name = "lbTargetgrp"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.myvpc.id

    health_check {
      path = "/"
      port = "traffic-port"
    }
  
}
resource "aws_lb_target_group_attachment" "attach1" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.server1.id
    port = 80
  
}
resource "aws_lb_target_group_attachment" "attach2" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.server2.id
    port = 80
  
}
resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.myalb.arn
    port = 80
    protocol = "HTTP"
    
    default_action {
      target_group_arn = aws_lb_target_group.tg.arn
      type = "forward"
    }
  
}
output "loadbalancerdns" {
    value = aws_lb.myalb.dns_name
  
}
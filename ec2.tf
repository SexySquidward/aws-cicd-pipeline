

resource "aws_launch_template" "WebServer" {
  security_group_names = [ aws_security_group.Allow_web.id ]
  name_prefix   = "WebServer"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y  
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c "echo your very first web server > /var/www/html/index.html"
              EOF
}

resource "aws_autoscaling_group" "asg" {
  
  vpc_zone_identifier = [aws_subnet.Wp_subnet_1.id,aws_subnet.Wp_subnet_2.id]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = aws_launch_template.WebServer.id
    version = "$Latest"
  }
}

resource "aws_lb" "elb" {
  name               = "Wpelb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.Wp_subnet_1.id,aws_subnet.Wp_subnet_2.id]
  tags = {
    Environment = "production"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_lb.elb.id
}
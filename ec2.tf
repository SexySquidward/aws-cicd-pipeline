

resource "aws_launch_template" "WebServer" {
  vpc_security_group_ids = [ aws_security_group.Allow_web.id ]
  name_prefix   = "WebServer"
  image_id      = "ami-05f998315cca9bfe3"
  instance_type = "t2.micro"
  user_data = filebase64("user_data/userdata.sh")
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
  elb                    = aws_elb.elb.id
}
resource "aws_lb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = var.name
  }
}

resource "aws_launch_template" "launch" {
  name_prefix   = var.name
  image_id      = data.aws_ami_ids.amazon.ids[0]
  instance_type = "t3.micro"
  user_data = filebase64("${path.module}/user_data.sh")
  vpc_security_group_ids = [aws_security_group.host.id]

  instance_initiated_shutdown_behavior = "terminate"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  instance_market_options {
    market_type = "spot"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_autoscaling_group" "asg" {
  name = var.name
  vpc_zone_identifier = var.private_subnets
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.launch.id
    version = "$Latest"
  }

}

resource "aws_autoscaling_attachment" "asg" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  alb_target_group_arn = aws_alb_target_group.alb_target_group.arn
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  tags = {
    Name = var.name
  }
}

resource "aws_alb_target_group" "alb_target_group" {  
  name     = var.name
  port     = "80"  
  protocol = "HTTP"  
  vpc_id   = var.vpc_id   
  
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = "80"  
  }

  tags = {
    Name = var.name
  }
}

data "aws_ami_ids" "amazon" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "alb" {
  name        = "alb_allow_http_traffic"
  description = "Allow ALL"
  vpc_id      = var.vpc_id

  ingress {
    description      = ""
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "host" {
  name        = "allow_http_traffic_from_alb"
  description = "Allow ALB"
  vpc_id      = var.vpc_id

  ingress {
    description      = ""
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.name
  }
}


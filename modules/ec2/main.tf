resource "aws_instance" "ec2" {
  ami           = data.aws_ami_ids.amazon.ids[0]
  instance_type = var.instance_type
  key_name      = var.key_name

  disable_api_termination = false
  monitoring              = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = "false"
  }

user_data = <<-EOT
  #!/bin/bash
  yum -y update
  yum -y install httpd 
  systemctl start httpd
  systemctl enable httpd
  INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  echo "Instance: Terraform - $INSTANCE_ID" > /var/www/html/index.html
EOT

  tags = { 
        Name = var.name 
  }

  volume_tags = { 
        Name = var.name
  }

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ec2.id]
 
  
}


data "aws_ami_ids" "amazon" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_security_group" "ec2" {
  name        = "ec2__traffic"
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
    Environment = var.name
    Name = var.name
  }
}




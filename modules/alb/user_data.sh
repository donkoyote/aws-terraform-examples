#!/bin/bash
  yum -y update
  yum -y install httpd 
  systemctl start httpd
  systemctl enable httpd
  INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  echo "Instance: Terraform - $INSTANCE_ID" > /var/www/html/index.html
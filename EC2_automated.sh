#!/bin/bash
echo "Install nginx"
sudo yum install -y nginx
echo " Create user"
sudo useradd test_user
echo "Configure SSH"
sudo sed -i 's|#PermitRootLogin.*|PermitRootLogin no|' /etc/ssh/sshd_config
echo "Start nginx"
sudo systemctl start nginx

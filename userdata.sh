#!/bin/bash

# System Updates
sudo yum -y update
sudo yum -y upgrade

# Install Webserver
sudo yum install -y httpd

sudo sh -c 'echo "Hello, World." > /var/www/html/index.html'

# Start and enable Webserver
sudo systemctl start httpd
sudo systemctl enable httpd

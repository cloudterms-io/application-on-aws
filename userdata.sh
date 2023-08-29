#!/bin/bash

# System Updates
sudo yum -y update
sudo yum -y upgrade

# Install Webserver
sudo yum install -y httpd

# Start and enable Webserver
sudo systemctl enable httpd
sudo systemctl start httpd

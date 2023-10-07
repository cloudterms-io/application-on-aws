#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl start nginx
sudo systemctal enable nginx
sudo sh -c 'echo "Hello, Mr. iki. How are you? :p" > /usr/share/nginx/html/index.html' 
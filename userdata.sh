#!/bin/bash

# System Updates
sudo yum -y update
sudo yum -y upgrade

# env setup
REGION="ap-northeast-1"

DBPassword=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBPassword --with-decryption --query Parameters[0].Value)
DBPassword=$(echo $DBPassword | sed -e 's/^"//' -e 's/"$//')

DBUser=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBUser --query Parameters[0].Value)
DBUser=$(echo $DBUser | sed -e 's/^"//' -e 's/"$//')

DBName=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBName --query Parameters[0].Value)
DBName=$(echo $DBName | sed -e 's/^"//' -e 's/"$//')

DBEndpoint=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBEndpoint --query Parameters[0].Value)
DBEndpoint=$(echo $DBEndpoint | sed -e 's/^"//' -e 's/"$//')

DBHostname=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBHostname --query Parameters[0].Value)
DBHostname=$(echo $DBHostname | sed -e 's/^"//' -e 's/"$//')

EFSID=$(aws ssm get-parameters --region $REGION --names /wordpress/efs/EFSID --query Parameters[0].Value)
EFSID=$(echo $EFSID | sed -e 's/^"//' -e 's/"$//')

# Install the application dependencies you need for WordPress
sudo yum install -y httpd wget 
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

# Download and install Composer globally
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Verify Composer installation
composer --version

# Install the Amazon EFS utilities
sudo yum -y install amazon-efs-utils

sudo systemctl start httpd
sudo systemctl enable httpd

echo "Hello" > /var/www/html/index.html
sudo chown -R ec2-user:apache /var/www

sudo systemctl restart httpd
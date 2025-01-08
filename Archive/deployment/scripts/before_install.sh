#!/bin/bash

# Update package list and install required packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php php-mysql php-json

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Create deployment directory if it doesn't exist
mkdir -p /var/www/html

# Set correct permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Clean up the deployment directory
rm -rf /var/www/html/*

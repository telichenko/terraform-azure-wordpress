#!/bin/bash
set -e

# Update packages and install NGINX
sudo apt-get update -y
sudo apt-get install -y nginx software-properties-common

# Copy the SSL certificate files
sudo cp /tmp/ssl_certificate.crt /etc/ssl/ssl_certificate.crt
sudo cp /tmp/ssl_certificate.key /etc/ssl/ssl_certificate.key

# Write the NGINX configuration
sudo bash -c "cat > /etc/nginx/sites-available/wordpress <<EOF
${nginx_config}
EOF"

# Configure NGINX
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
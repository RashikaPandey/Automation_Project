#!/bin/bash
sudo apt update -y
#checking apache service
if ! dpkg -s apache2 >/dev/null 2>&1; then
    echo "apache2 is not installed. Installing..."
    sudo apt update -y
    sudo apt install apache2 -y
fi

#checking apache status
if ! systemctl is-active --quiet apache2; then
    echo "apache2 is not running. Starting service..."
    sudo systemctl start apache2
fi

#checking whether apache is enabled or not

if ! systemctl is-enabled --quiet apache2; then
    echo "apache2 is not enabled. Enabling service..."
    sudo systemctl enable apache2
fi

timestamp=$(date '+%d%m%Y-%H%M%S')
name="rashika"
s3_bucket="upgrad-rashikapandey"
tar -cvf /tmp/$name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar s3://$s3_bucket/$name-httpd-logs-$timestamp.tar

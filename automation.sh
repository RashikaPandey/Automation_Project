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


#code by saurabh 

LOG_TYPE="httpd-logs"
#ARCHIVE_DATE=$(date +%m%d%Y-%H%M%S)
ARCHIVE_TYPE="tar"
file_name=/tmp/$name-httpd-logs-$timestamp.tar
ARCHIVE_SIZE=$(du -h $file_name | awk '{print $1}')

if [ ! -f /var/www/html/inventory.html ]; then
  # If not found, create it with header
  echo -e "Log Type\tDate Created\tType\tSize" > /var/www/html/inventory.html
fi

# Append new entry to inventory.html
echo -e "${LOG_TYPE}\t${timestamp}\t${ARCHIVE_TYPE}\t${ARCHIVE_SIZE}" >> /var/www/html/inventory.html

 script_path="/etc/cron.d/automation"



# Check if the cron job is already scheduled
if [ -f $script_path ]; then
    echo "Cron job is already scheduled."
else
    # Create the cron job file
    echo "Creating cron job file..."
    touch /etc/cron.d/automation

    # Set permissions for the cron job file
    chmod 644 /etc/cron.d/automation

    # Add te cron job to the file
    echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation

    echo "Cron job scheduled successfully."
fi

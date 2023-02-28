# Automation_Project

Creating automation task on ec2 machine for the hosted website as daily requests to web servers generate lots of access logs.
The script checks apache2 services are up and restarts automatically in case the EC2 instance reboots and logs (Access and Error) generated are getting archived and stored in S3 bucket. This is ensured by running the task at regular interval through cron job. 

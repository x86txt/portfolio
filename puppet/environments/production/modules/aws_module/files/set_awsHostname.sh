#!/bin/bash
REGION=`/usr/bin/curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | /usr/bin/jq -r .region`
AWS_INSTANCE_ID=`/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/instance-id`
EC2_NAME=$(/usr/bin/aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$AWS_INSTANCE_ID" "Name=key,Values=Name" --output text | /usr/bin/cut -f5 && touch /tmp/hostname.set)
echo $EC2_NAME > /etc/hostname
/usr/bin/hostname -F /etc/hostname

#!/bin/bash

# Fetch the instance ID and local IP using the EC2 metadata service
# Note: Using token-based IMDSv2 (Standard for modern AMIs)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
LOCAL_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat > index.html <<EOF
<h1>${server_text}This is ${day} !</h1>
EOF

nohup busybox httpd -f -p ${server_port} &


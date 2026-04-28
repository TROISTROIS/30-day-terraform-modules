#!/bin/bash

# Fetch the instance ID and local IP using the EC2 metadata service
# Note: Using token-based IMDSv2 (Standard for modern AMIs)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
LOCAL_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat > index.html <<EOF
<h1>Woohoo!!! Day 09 of the Terraform Challenge on ${Environment} !</h1>
<p><strong>Instance ID:</strong> $INSTANCE_ID</p>
<p><strong>Internal IP:</strong> $LOCAL_IP</p>
<p><strong>Server Port:</strong> ${server_port}</p>
<p><em>Testing Version: v0.0.4-beta</em></p>
EOF

nohup busybox httpd -f -p ${server_port} &


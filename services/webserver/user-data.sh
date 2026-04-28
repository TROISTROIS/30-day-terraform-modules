#!/bin/bash
cat > index.html <<EOF
<h1>Woohoo!!! Day 09 of the Terraform Challenge on ${Environment} !</h1>
EOF
nohup busybox httpd -f -p ${server_port} &


#!/bin/bash

# Install HAProxy
sudo apt update
sudo apt install haproxy -y

# Edit HAProxy configuration file
sudo nano /etc/haproxy/haproxy.cfg

# Copy and paste the configuration below into the file
cat <<EOL | sudo tee /etc/haproxy/haproxy.cfg
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode tcp
    option tcplog
    option dontlognull
    timeout connect 5000
    timeout client 50000
    timeout server 50000

frontend gpu_frontend
#    bind *:80 ssl crt /etc/ssl/certs/haproxy.pem
    bind *:80
    mode tcp
    default_backend gpu_backend

backend gpu_backend
    mode tcp
    balance roundrobin
    server gpu_server us.pyrin.herominers.com:1177

frontend cpu_frontend
#    bind *:2053 ssl crt /etc/ssl/certs/haproxy.pem
    bind *:2053
    mode tcp
    default_backend cpu_backend

backend cpu_backend
    mode tcp
    balance roundrobin
    server cpu_server nimiq.icemining.ca:2053
EOL

# Save and exit from the editor

# Restart HAProxy
sudo service haproxy restart

#!/bin/bash

# Install Shadowsocks and Simple-obfs
sudo apt update
sudo apt install shadowsocks-libev simple-obfs -y

# Set configuration options
read -p "Enter username for Shadowsocks: " username
read -s -p "Enter password for Shadowsocks: " password
echo ""

# Configure Shadowsocks
sudo tee /etc/shadowsocks-libev/config.json > /dev/null << EOF
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "password": "$password",
    "method": "aes-256-gcm",
    "plugin": "obfs-server",
    "plugin_opts": "obfs=http;obfs-host=www.bing.com",
    "mode": "tcp_and_udp",
    "timeout": 300
}
EOF

# Start and enable Shadowsocks service
sudo systemctl start shadowsocks-libev
sudo systemctl enable shadowsocks-libev

# Print configuration details
echo "Shadowsocks server is now running."
echo "Server IP: $(curl -s http://checkip.amazonaws.com)"
echo "Server Port: 8388"
echo "Username: $username"
echo "Password: $password"
echo "Encryption Method: aes-256-gcm"
echo "Plugin: simple-obfs"
echo "Plugin Options: obfs=http;obfs-host=www.bing.com"

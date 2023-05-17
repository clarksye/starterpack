#!/bin/bash

# Step 2: Install Dante
sudo apt update
sudo apt install dante-server

# Step 3: Configure Dante
sudo tee /etc/sockd.conf > /dev/null << EOL
internal: eth0 port = 1080
external: eth0
clientmethod: none
user.privileged: root
user.notprivileged: nobody
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
    method: username
}
EOL

# Step 4: Create User and Password
sudo touch /etc/sockd.passwd
sudo /usr/sbin/sockd -N -n -f /etc/sockd.conf -p /var/run/sockd.pid
sudo sockdpasswd -c /etc/sockd.passwd username
# Ganti 'username' dengan nama pengguna yang Anda inginkan
# Anda akan diminta untuk memasukkan dan mengonfirmasi kata sandi

sudo pkill sockd

# Step 5: Restart Dante
sudo systemctl restart danted

echo "Dante SOCKS5 server setup completed."

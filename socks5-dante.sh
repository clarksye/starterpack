#!/bin/bash

sudo apt-get update
sudo apt-get install -y dante-server

sudo rm /etc/danted.conf
sudo tee /etc/danted.conf > /dev/null << EOL
logoutput: syslog
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=443

# The proxying network interface or address.
external: eth0

# socks-rules determine what is proxied through the external interface.
socksmethod: username

# client-rules determine who can connect to the internal interface.
clientmethod: none

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}

EOL

sudo useradd -r -s /bin/false clarksye
echo -e "user123\nuser123" | sudo passwd clarksye


sudo systemctl restart danted.service

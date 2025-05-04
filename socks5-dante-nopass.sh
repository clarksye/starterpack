#!/bin/bash

sudo apt update && sudo apt install -y dante-server

sudo rm -f /etc/danted.conf

sudo tee /etc/danted.conf > /dev/null << EOL
logoutput: syslog
internal: 0.0.0.0 port=443
external: eth0
socksmethod: none
clientmethod: none
user.privileged: root
user.unprivileged: nobody
user.libwrap: nobody
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}
EOL

sudo systemctl restart danted.service

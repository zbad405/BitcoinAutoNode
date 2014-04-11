#!/bin/bash
# Made by TheZero
#
# Dependency
#apt-get install build-essential libssl-dev libboost-all-dev libdb4.8-dev libdb4.8++-dev git
#

echo "- Started! -"
cd /opt

#Download Zetacoin
git clone https://github.com/zetacoin/zetacoin.git
cd zetacoin/src/
make -f makefile.unix 
ln -s /opt/zetacoin/src/zetacoind /usr/bin/

#Linux Firewall rule
ufw allow 17333/tcp
ufw --force enable

# Creating Swap
dd if=/dev/zero of=/swapfile bs=1M count=1024 ; mkswap /swapfile ; swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# Creating config
config=".zetacoin/zetacoin.conf"
touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "connections=40" >> $config
echo "rpcallowip=127.*.*.*" >> $config
echo "rpcport=17335" >> $config
echo "port=17333" >> $config
echo "listen=1" >> $config
echo "txindex=1" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

# Ok, we are ready :)
nohup zetacoind &

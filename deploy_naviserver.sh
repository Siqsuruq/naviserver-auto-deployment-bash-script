#!/bin/bash

ns_dir="/opt/ns"
pg_pass="P.0stgr35#"
echo "Naviserver install dir: " $ns_dir

apt-get update
yes | apt-get install unzip tcl tcl-dev tk tk-dev tcllib tdom libssl-dev libpq-dev automake postgresql postgresql-contrib


sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$ps_pass';"

mkdir ns_install
cd ns_install
# wget https://bitbucket.org/naviserver/naviserver/get/naviserver-4.99.18.zip
wget https://bitbucket.org/naviserver/naviserver/get/tip.zip
unzip *zip
cd naviserver-naviserver*
./autogen.sh --prefix=$ns_dir --enable-symbols --enable-threads
make
make install
useradd nsadmin
chown -R nsadmin:nsadmin $ns_dir/logs
chown -R nsadmin:nsadmin $ns_dir/pages
$ns_dir/bin/nsd -u nsadmin -t $ns_dir/conf/nsd-config.tcl -f



make PGINCLUDE=/usr/include/postgresql/
P.0stgr35#
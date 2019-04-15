#!/bin/bash

apt-get update
yes | apt-get install unzip tcl tcl-dev tk tk-dev tcllib tdom libssl-dev libpq-dev automake postgresql postgresql-contrib


sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'P.0stgr35#';"

mkdir ns_install
cd ns_install
wget https://bitbucket.org/naviserver/naviserver/get/45f90be2b7d5.zip
unzip *zip
cd naviserver-naviserver*
./autogen.sh --prefix=/opt/ns --enable-symbols --enable-threads
make
make install
useradd nsadmin
chown -R nsadmin:nsadmin /opt/ns/logs
chown -R nsadmin:nsadmin /opt/ns/pages
/opt/ns/bin/nsd -u nsadmin -t /opt/ns/conf/nsd-config.tcl -f



make PGINCLUDE=/usr/include/postgresql/
P.0stgr35#
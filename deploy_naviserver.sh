#!/bin/bash

ns_dir="/opt/ns"
pg_incl=/usr/include/postgresql
pg_lib=/usr/lib
pg_user=postgres

echo "Naviserver install dir: " $ns_dir

apt-get update
yes | apt-get install unzip tcl tcl-dev tcllib tdom libssl-dev libpq-dev automake postgresql postgresql-contrib


sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'P.0stgr35#';"

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

echo "---------------------- Done installing Naviserver ---------------------"
echo "Cleaning:"
cd ..
rm -R ./naviserver-naviserver*
rm -R *.zip

echo "---------------------- Download and install nsdbpg ---------------------- "
wget https://bitbucket.org/naviserver/nsdbpg/get/tip.zip
unzip *zip
cd naviserver-nsdbpg*
make NAVISERVER=$ns_dir PGINCLUDE=$pg_incl
make install
cd ..
rm -R ./naviserver-nsdbpg*
rm -R *.zip

echo "---------------------- Starting Naviserver ---------------------- "
$ns_dir/bin/nsd -u nsadmin -t $ns_dir/conf/nsd-config.tcl -f


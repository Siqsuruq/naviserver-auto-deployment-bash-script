#!/usr/bin/env bash

# Defining some output colours
RED='\033[0;31m'
BL='\033[0;94m'
GR='\033[0;32m'
NC='\033[0m' # No Color
###############################

ns_dir="/opt/ns"
pg_incl=/usr/include/postgresql
pg_lib=/usr/lib
pg_user=postgres
pg_pass='P.0stgr35#'
echo "Naviserver install dir: " $ns_dir

function update_ubuntu () {
	echo -e "${BL}------------------ Updating Ubuntu: ------------------{NC}"
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get -y install unzip tcl tcl-dev tcllib tdom tcl-tls libssl-dev libpng-dev libpq-dev automake postgresql postgresql-contrib nsf nsf-shells fortune mc file git
	echo -e "${GR}------------------ Done$ ------------------{NC}"
}

function set_pg_pass () {
	echo -e "${BL}------------------ Setting up postgres password: ------------------{NC}"
	sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$1';"
	echo -e "${GR}------------------ Done$ ------------------{NC}"
}

function install_ns_module () {
	echo -e "${BL}------------------ Installing Naviserver Module: ------------------{NC}"
	mkdir nsm_install
	cd nsm_install
	wget @1
	unzip *.zip
	cd naviserver-*
	make NAVISERVER=$ns_dir PGINCLUDE=$pg_incl
	make NAVISERVER=$ns_dir install
	cd ../
	rm -R ./naviserver-*
	rm -R *.zip
	cd ../
	echo -e "${GR}------------------ Done$ ------------------{NC}"
}

update_ubuntu

set_pg_pass $pg_pass


mkdir ns_install
cd ns_install
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
cd ../
rm -R ./naviserver-naviserver*
rm -R *.zip

echo "---------------------- Download and install nsdbpg ---------------------- "
install_ns_module https://bitbucket.org/naviserver/nsdbpg/get/tip.zip
# wget https://bitbucket.org/naviserver/nsdbpg/get/tip.zip
# unzip *zip
# cd naviserver-nsdbpg*
# make NAVISERVER=$ns_dir PGINCLUDE=$pg_incl
# make install NAVISERVER=$ns_dir
# cd ../
# rm -R ./naviserver-nsdbpg*
# rm -R *.zip
# cd ../
install_ns_module https://bitbucket.org/naviserver/nsfortune/get/tip.zip
echo "---------------------- Starting Naviserver ---------------------- "
# $ns_dir/bin/nsd -u nsadmin -t $ns_dir/conf/nsd-config.tcl -f


cp ./naviserver.service /etc/systemd/system/
cp ./naviserver /etc/init.d/ 
chmod a+x /etc/init.d/naviserver
cp $ns_dir/conf/nsd-config.tcl $ns_dir/conf/nsd.conf

systemctl daemon-reload
systemctl enable naviserver.service
service naviserver start

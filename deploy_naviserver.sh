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
echo "Naviserver install dir: " $ns_dir

function update_ubuntu () {
	echo -e "${BL}------------------ Updating Ubuntu: ------------------{NC}"
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get -y install unzip tcl tcl-dev tcllib tdom tcl-tls libssl-dev libpng-dev libpq-dev automake postgresql postgresql-contrib nsf nsf-shells fortune mc file git gcc
	echo -e "${GR}------------------ Done$ ------------------{NC}"
}

function install_ns_module () {
	echo -e "${BL}------------------ Installing Naviserver Module: $2 ------------------ ${NC}"
	mkdir nsm_install
	cd nsm_install
	wget $1
	unzip *.zip
	cd naviserver-*
	make NAVISERVER=$ns_dir PGINCLUDE=$pg_incl
	make NAVISERVER=$ns_dir install
	cd ../
	rm -R ./naviserver-*
	rm -R *.zip
	cd ../
	rm -R ./nsm_install
	echo -e "${BL}------------------ Done ------------------ ${NC}"
}

function install_ns () {
	echo -e "${RED} ------------------ Installing Naviserver: ------------------ ${NC}"
	mkdir ns_install
	cd ns_install
	wget https://bitbucket.org/naviserver/naviserver-hg/get/tip.zip
	unzip *zip
	cd naviserver-naviserver*
	./autogen.sh --prefix=$ns_dir --enable-symbols --enable-threads
	make
	make install
	useradd nsadmin
	chown -R nsadmin:nsadmin $ns_dir/logs
	chown -R nsadmin:nsadmin $ns_dir/pages
	echo "-------------------------------------------"
	echo "Cleaning:"
	cd ../
	rm -R ./naviserver-naviserver*
	rm -R *.zip
	cd ../
	rm -R ./ns_install
	echo -e "${RED} ------------------ Done installing Naviserver ------------------ ${NC}"
}

function ns_startup () {
	echo -e "${RED} ------------------ Installing Naviserver StartUp Scripts: ------------------ ${NC}"
	mkdir ns_install
	cd ns_install
	wget https://github.com/Siqsuruq/naviserver-auto-deployment-bash-script/raw/master/naviserver
	wget https://github.com/Siqsuruq/naviserver-auto-deployment-bash-script/raw/master/naviserver.service
	cp ./naviserver /etc/init.d/
	cp ./naviserver.service /etc/systemd/system/
	chmod a+x /etc/init.d/naviserver
	cd ../
	rm -R ./ns_install
	
	cp $ns_dir/conf/nsd-config.tcl $ns_dir/conf/nsd.conf
	echo -e "${RED} ---------------------- Starting Naviserver ---------------------- ${NC}"
	systemctl daemon-reload
	systemctl enable naviserver.service
	service naviserver start
}
# update_ubuntu

# Start from here,just ns
install_ns
install_ns_module https://bitbucket.org/naviserver/nsdbpg-hg/get/tip.zip NS_DBPG
install_ns_module https://bitbucket.org/naviserver/nsfortune-hg/get/tip.zip NS_FORTUNE
ns_startup

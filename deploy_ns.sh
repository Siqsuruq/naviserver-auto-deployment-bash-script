#!/usr/bin/env bash

# Defining some output colours
RED='\033[0;31m'
BL='\033[0;94m'
GR='\033[0;32m'
NC='\033[0m' # No Color
###############################

ns_dir="/opt/ns"
run_apt=no
install_ns=no
install_start=no
pg_incl=/usr/include/postgresql
pg_lib=/usr/lib
ns_module=""
ns_build=main

declare -A ns_modules
ns_modules[NS_DBPG]=https://bitbucket.org/naviserver/nsdbpg/get/main.zip
ns_modules[NS_DBI]=https://bitbucket.org/naviserver/nsdbi/get/main.zip
ns_modules[NS_DBIPG]=https://bitbucket.org/naviserver/nsdbipg/get/main.zip
ns_modules[NS_FORTUNE]=https://bitbucket.org/naviserver/nsfortune/get/main.zip

# Usage info
function show_help()
{
echo -e "${BL}
	Usage: deploy_ns.sh [-u] [-d NS Install Dir]
	
	-i		Install Naviserver
	-d		Change Naviserver install directory (Default: /opt/ns)
	-b		Install specific Naviserver Bitbucket Repo commit
	-u		Will run 'apt-get update' first and install all Ubuntu packages dependencies
	-s		Install StartUp Scripts
	-m		Install NS Module (NS_DBPG NS_FORTUNE NS_DBI NS_DBIPG)
	-h		Show this Help
		
${NC}"
exit 1;
}

function update_ubuntu () {
	echo -e "${BL}------------------ Updating Ubuntu: ------------------${NC}"
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get -y install unzip tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev automake postgresql postgresql-contrib postgresql-pltcl nsf nsf-shells fortune fortunes mc file git gcc zip
	echo -e "${GR}------------------ Done$ ------------------${NC}"
}

function proceed () {
	read -p "Are you sure? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		if [ "$run_apt" = "yes" ];	then
			update_ubuntu
		fi
		
		if [ "$install_ns" = "yes" ]; then
			install_ns
		fi
		
		if [ "$install_start" = "yes" ]; then
			ns_startup
		fi
		
		if [ "$ns_module" != "" ]; then
			install_ns_module $ns_module
		fi
	fi
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

function install_ns () {
	echo -e "${RED} ------------------ Installing Naviserver: ------------------ ${NC}"
	mkdir ns_install
	cd ns_install
	wget https://bitbucket.org/naviserver/naviserver/get/$ns_build.zip
	unzip *zip
	cd naviserver-naviserver*
	./autogen.sh --prefix=$ns_dir --enable-symbols --enable-threads --htmldir=$ns_dir/doc
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

function install_ns_module () {
	echo -e "${BL}------------------ Installing Naviserver Module ------------------ ${NC}"
	
	mkdir nsm_install
	cd nsm_install
	wget ${ns_modules[$1]}
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

while getopts "d:m:b:uish" opt; do
	case $opt in
		d) ns_dir="$OPTARG";;
		u) run_apt=yes ;;
		i) install_ns=yes ;;
		s) install_start=yes ;;
		m) ns_module="$OPTARG";;
		b) ns_build="$OPTARG";;
		h) show_help ;;
	esac
done

echo
echo -e "${BL}------------------ Welcome to Naviserver Install Script: ------------------${NC}"
echo "For help with options, run: ./deploy_ns.sh -h"
echo -e "${GR}------------------------------------------------"
echo 
echo " Run apt-get: " $run_apt
echo " Install Naviserver: " $install_ns
echo " Naviserver Build: " $ns_build
echo " Install StartUp Scripts: " $install_start
echo " Install NS Module: " 
echo " Naviserver dir: " $ns_dir
echo 
echo -e "------------------------------------------------${NC}"

proceed
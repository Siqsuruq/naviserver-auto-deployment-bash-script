# naviserver-auto-deployment-bash-script
This is simple naviserver auto deployment bash script for Ubuntu.
I have tested it on Ubuntu 18.xx , but it should work on other systems as well.

Bascic usage as root, from terminal:
```
wget https://github.com/Siqsuruq/naviserver-auto-deployment-bash-script/raw/master/deploy_ns.sh
chmod a+x deploy_ns.sh
./deploy_ns.sh -i -u -d /opt/ns -s -m NS_DBPG
```
Usage: deploy_ns.sh [-u] [-d NS Install Dir] -i

Options:

        -i              Install Naviserver
        -d              Change Naviserver install directory (Default: /opt/ns)
        -u              Will run 'apt-get update' first and install all Ubuntu packages dependencies
        -s              Install StartUp Scripts
        -m              Install NS Module (NS_DBPG NS_FORTUNE)
        -h              Show this Help

It will download and install latest naviserver from source code.

Enjoy

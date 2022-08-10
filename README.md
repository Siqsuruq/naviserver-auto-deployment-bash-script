# naviserver-auto-deployment-bash-script
This is simple naviserver auto deployment bash script for Ubuntu.
I have tested it on Ubuntu 18.xx, 20.xx , but it should work on other systems as well.

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
		-b              Install specific Naviserver Bitbucket Repo commit
        -u              Will run 'apt-get update' first and install all Ubuntu packages dependencies
        -s              Install StartUp Scripts
        -m              Install NS Module (NS_DBPG NS_FORTUNE NS_DBI NS_DBIPG)
        -h              Show this Help

It will download and install latest naviserver from source code.

Examples:

1) Install Naviserver and all dependencies on a new "fresh" Ubuntu, without any modules:
```
./deploy_ns.sh -i -u -s
```

2) Update Naviserver already installed on default location (/opt/ns):
```
./deploy_ns.sh -i
```

2) Update/Downgrade Naviserver to specific commit number in BitBucket repository (default is master) :
```
./deploy_ns.sh -i -b e11e014
```

Enjoy

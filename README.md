# naviserver-auto-deployment-bash-script
This is simple naviserver auto deployment bash script for Ubuntu.
I have tested it on Ubuntu 18.xx and 19.xx, but it should work on other systems as well.

Bascic usage as root, from terminal:
```
wget https://github.com/Siqsuruq/naviserver-auto-deployment-bash-script/raw/master/deploy_naviserver.sh
chmod a+x deploy_naviserver.sh
./deploy_naviserver.sh
```
It will download and install latest naviserver from source code, also naviserver modules NSDBPG and NSFORTUNE.
For fresh instalation you will need a lot of other software, just uncomment line 
```
# update_ubuntu
```

Enjoy

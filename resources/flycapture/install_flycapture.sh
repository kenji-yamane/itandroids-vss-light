#!/bin/bash

set -o errexit

MY_PROMPT='$ '
MY_YESNO_PROMPT='(y/n)$ '

# version of the software
MAJOR_VERSION=2
MINOR_VERSION=10
# 0 Alpha, 1 Beta, 2 RC, 3 Public release
RELEASE_TYPE=3
RELEASE_BUILD=0
RELEASE_TYPE_TEXT=Release

echo "This is a script to assist with installation of the FlyCapture2 SDK.";
echo

echo "Installing FlyCapture2 packages...";

sudo dpkg -i libflycapture-2*
sudo dpkg -i libflycapturegui-2*
sudo dpkg -i libflycapture-c-2*
sudo dpkg -i libflycapturegui-c-2*
sudo dpkg -i libmultisync-2*
sudo dpkg -i libmultisync-c-2*
sudo dpkg -i flycap-2*
sudo dpkg -i flycapture-doc-2*
sudo dpkg -i updatorgui*


echo "Launching conf script";
#sudo sh flycap2-conf

echo "Complete";

#notify server of a linux installation
#wget -T 10 -q --spider http://www.ptgrey.com/support/softwarereg.asp?text=ProductName+Linux+FlyCapture2+$MAJOR_VERSION%2E$MINOR_VERSION+$RELEASE_TYPE_TEXT+$RELEASE_BUILD+%0D%0AProductVersion+$MAJOR_VERSION%2E$MINOR_VERSION%2E$RELEASE_TYPE%2E$RELEASE_BUILD%0D%0A

exit 0

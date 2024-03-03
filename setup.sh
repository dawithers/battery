#!/bin/bash

# User welcome message
echo -e "\n####################################################################"
echo '# 👋 Welcome, this is the setup script for the battery CLI tool.'
echo -e "# Note: this script will ask for your password once or multiple times."
echo -e "####################################################################\n\n"

# Set environment variables
tempfolder=~/.battery-tmp
binfolder=/usr/local/bin
mkdir -p $tempfolder

# Set script value
calling_user=${1:-"$USER"}
configfolder=/Users/$calling_user/.battery
logfile=$configfolder/battery.log


# Ask for sudo once, in most systems this will cache the permissions for a bit
sudo echo "🔋 Starting battery installation"
echo -e "[ 1 ] Superuser permissions acquired."

# Note: github names zips by <reponame>-<branchname>.replace( '/', '-' )
update_branch="main"
in_zip_folder_name="battery-$update_branch"
batteryfolder="$tempfolder/battery"
echo "[ 2 ] Downloading latest version of battery CLI"
rm -rf $batteryfolder
mkdir -p $batteryfolder
curl -sSL -o $batteryfolder/repo.zip "https://github.com/dawithers/battery/archive/refs/heads/$update_branch.zip"
unzip -qq $batteryfolder/repo.zip -d $batteryfolder
cp -r $batteryfolder/$in_zip_folder_name/* $batteryfolder
rm $batteryfolder/repo.zip

# Move built files to bin folder
echo "[ 3 ] Move smc to executable folder"
sudo mkdir -p $binfolder
sudo cp $batteryfolder/dist/smc/smc $binfolder
sudo chown $calling_user $binfolder/smc
sudo chmod 755 $binfolder/smc
sudo chmod +x $binfolder/smc
sudo cp $batteryfolder/dist/bclm/bclm $binfolder
sudo chown $calling_user $binfolder/bclm
sudo chmod 755 $binfolder/bclm
sudo chmod +x $binfolder/bclm

echo "[ 4 ] Writing script to $binfolder/battery for user $calling_user"
sudo cp $batteryfolder/battery.sh $binfolder/battery

echo "[ 5 ] Setting correct file permissions"
# Set permissions for battery executables
sudo chown $calling_user $binfolder/battery
sudo chmod 755 $binfolder/battery
sudo chmod +x $binfolder/battery

# Set permissions for logfiles
mkdir -p $configfolder
sudo chown $calling_user $configfolder

touch $logfile
sudo chown $calling_user $logfile
sudo chmod 755 $logfile

sudo chown $calling_user $binfolder/battery

echo "[ 6 ] Setting up visudo declarations"
sudo bash $binfolder/battery visudo

echo "[ 7 ] Setting up persistence file"
sudo $binfolder/bclm persist

# Remove tempfiles
cd ../..
echo "[ 8 ] Removing temp folder $tempfolder"
rm -rf $tempfolder

echo -e "\n🎉 Battery tool installed. Type \"battery help\" for instructions.\n"

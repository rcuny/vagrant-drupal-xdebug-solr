#! /bin/bash

##### INFO #####

# Provision.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#
# Author: Jurgen Verhasselt - https://github.com/sjugge
# Modified by: Renaud Cuny for Boleia - https://github.com/rcuny


##### VARIABLES #####

# Throughout this script, some variables are used, these are defined first.
# These variables can be altered to fit your specific needs or preferences.

# Server name
HOSTNAME="vagrant.dcl"

# Locale
LOCALE_LANGUAGE="en_US" # can be altered to your prefered locale, see http://docs.moodle.org/dev/Table_of_locales
LOCALE_CODESET="en_US.UTF-8"

# Timezone
TIMEZONE="Europe/Paris" # can be altered to your specific timezone, see http://manpages.ubuntu.com/manpages/jaunty/man3/DateTime::TimeZone::Catalog.3pm.html

# PHP settings
MEMORY_LIMIT="256M"
UPLOAD_MAX_FILESIZE="128M"
POST_MAX_SIZE="128M"

# Drush
DRUSH_VERSION="6.2.0" # prefered Drush release from https://github.com/drush-ops/drush/releases

#----- end of configurable variables -----#


##### PROVISION CHECK ######

# The provision check is intented to not run the full provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "[vagrant provisioning] Checking if the box was already provisioned..."

if [ -e "/home/vagrant/.provision_check" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant provisioning] The box is already provisioned..."
  exit
fi


##### PROVISION DRUPAL TOOLS #####

echo "[vagrant provisioning] Installing LAMP stack..."

# Set Locale, see https://help.ubuntu.com/community/Locale#Changing_settings_permanently
echo "[vagrant provisioning] Setting locale..."
sudo locale-gen $LOCALE_LANGUAGE $LOCALE_CODESET

# Set timezone, for unattended info see https://help.ubuntu.com/community/UbuntuTime#Using_the_Command_Line_.28unattended.29
echo "[vagrant provisioning] Setting timezone..."
echo $TIMEZONE | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Download and update package lists
echo "[vagrant provisioning] Package manager updates..."
sudo apt-get update

# Install Drush
echo "[vagrant provisioning] Installing drush..."
sudo wget -q https://github.com/drush-ops/drush/archive/$DRUSH_VERSION.tar.gz # download drush from github
sudo tar -C /opt/ -xzf $DRUSH_VERSION.tar.gz # untar drush in /opt
sudo chown -R vagrant:vagrant /opt/drush-$DRUSH_VERSION # ensure the vagrant user has sufficiënt rights
sudo ln -s /opt/drush-$DRUSH_VERSION/drush /usr/sbin/drush # add drush to /usr/sbin
sudo rm -rf /home/vagrant/$DRUSH_VERSION.tar.gz # remove the downloaded tarbal


##### CONFIGURATION #####

# Changing PHP settings
echo "[vagrant provisioning] Configuring PHP5..."
# Change settings for apache2 PHP
sudo sed -i "s@MEMORY_LIMIT@$MEMORY_LIMIT@g" /etc/php5/apache2/php.ini
sudo sed -i "s@UPLOAD_MAX_FILESIZE@$UPLOAD_MAX_FILESIZE@g" /etc/php5/apache2/php.ini
sudo sed -i "s@POST_MAX_SIZE@$POST_MAX_SIZE@g" /etc/php5/apache2/php.ini
# Change settings for command line interface PHP (used by Drush)
sudo sed -i "s@MEMORY_LIMIT@$MEMORY_LIMIT@g" /etc/php5/cli/php.ini
sudo sed -i "s@UPLOAD_MAX_FILESIZE@$UPLOAD_MAX_FILESIZE@g" /etc/php5/cli/php.ini
sudo sed -i "s@POST_MAX_SIZE@$POST_MAX_SIZE@g" /etc/php5/cli/php.ini
sudo service apache2 restart # restart apache so latest php config is picked up

# Hostname
echo "[vagrant provisioning] Setting hostname..."
sudo hostname $HOSTNAME


##### CLEAN UP #####

sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
apt-get autoremove -y # remove obsolete packages


##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check

#!/bin/bash
#
# possible failure in terraform
# execute remote commands (enter Wordpress email, site, domain):
#    $ ./bin/wpinstall.sh do4@dennislwm.anonaddy.com Izzy klix.cam

#
# define variable
admin_user='admin'
dbname='wordpress'
dbuser='wordpress'
dbhost='localhost'
wpcli='wp --allow-root --path=/var/www/html'
file="/root/.litespeed_password"
wpfile="/root/bin/wpclirc.sh"
rcfile="/root/.bashrc"

#
# accept admin email of your website
if [ -z "$1" ]; then
    echo "Admin email for your WordPress is required"
    exit 1
fi
admin_email=$1
echo "Admin Email: $admin_email"
#
# accept the name of your website
if [ -z "$2" ]; then
    echo "Site name for your WordPress is required"
    exit 1
fi
sitename=$2
echo "Site Name: $sitename"
#
# accept the domain of your website
if [ -z "$3" ]; then
    echo "Domain URL for your WordPress is required"
    exit 1
fi
domain=$3
echo "Domain: $domain"
#
# read admin_pass from file
if [ -f $file ]; then
    echo "Sourcing $file"
    source "$file"
fi
if [ -z "$admin_pass" ]; then
    echo "Admin password for your WordPress is required"
    exit 1
fi
echo "Admin User: $admin_user"
echo "Admin Password: $admin_pass"

#
# does the file already exist?
if [ -x "$(command -v ) \'${wp-cli}\'" ]; then
    echo 'wp-cli installation appears to be missing which is required.' >&2
    exit 1
fi
if [ -x "$(command -v \'php --version\')" ]; then
    echo 'php-cli installation appears to be missing which is required.' >&2
    exit 1
fi

#
#
${wpcli} cli update
${wpcli} core install --url=${domain} --title="${sitename}" --admin_user=${admin_user} --admin_password=${admin_pass} --admin_email=${admin_email}

echo '--------------------------------------------'
echo 'Check whether the core was created or not?'
echo '--------------------------------------------'
${wpcli} config get
${wpcli} core update
${wpcli} core update-db

if [ -f $wpfile ]; then
    echo "source $wpfile" >> $rcfile
    source "$wpfile"
fi

#
# remove plugin
#${wpcli} plugin uninstall akismet all-in-one-wp-migration all-in-one-seo-pack google-analytics-for-wordpress hello jetpack wp-mail-smtp

#
# install plugin
#${wpcli} plugin install --activate auth0 disable-comments litespeed-cache patreon-connect restrict-user-access
#${wpcli} plugin install --activate simple-iframe simple-vertical-timeline smartvideo wp-githuber-md

#
# update plugin
#${wpcli} plugin update --all

#
# The trick is to add your user “demo” to the group www-data (since www-data is a group)
# add user “demo” to group “www-data” (below replace demo with your username)
#
sudo adduser demo --gecos 'First Last,RoomNumber,WorkPhone,HomePhone' --disabled-password
echo 'demo:demo' | sudo chpasswd
sudo usermod -aG www-data demo
sudo usermod -aG admin demo
sudo usermod -aG sudo demo
#
#set permissions for user group www-data
sudo chgrp -R www-data /var/www/html
sudo chmod -R g+w /var/www/html
#
# Now you can modify files as “demo” via SFTP and your wordpress installation can modify files without requesting credentials
# You should use wp-cli with demo account, instead of root
#   $ su - demo
#   $ sudo cp /root/bin/wpclirc.sh .
#   $ sudo chmod 666 wpclirc.sh
#   $ echo 'source ~/wpclirc.sh' >> .bashrc
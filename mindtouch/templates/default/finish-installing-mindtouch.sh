# These are the commands listed after you've provided the basic 
# admin info when installing mindtouch for the first time.

cd /var/www/dekiwiki/config
mkdir /etc/dekiwiki
cp -p mindtouch.host.conf /etc/dekiwiki
cp -p mindtouch.deki.startup.xml /etc/dekiwiki
cp -p LocalSettings.php /var/www/dekiwiki/
/etc/init.d/dekiwiki start

rm mindtouch.host.conf
rm mindtouch.deki.startup.xml
rm LocalSettings.php
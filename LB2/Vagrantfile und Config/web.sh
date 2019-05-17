#!/bin/bash
#LAMP ohne MySQL installieren und konfigurieren

# Packages vom lokalen Server holen
# DEBUG ON
set -o xtrace
sudo apt-get update
# Packages herunterladen
sudo apt-get -y install apache2 php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd php-mysql php-mbstring php-xml libapache2-mod-php php-mcrypt libxml2-dev
# Apache Rewrite Mod aktivieren
sudo a2enmod rewrite
# Apache Config testen
sudo apache2ctl configtest
# Apache neustarten
sudo systemctl restart apache2
# Ordner wechseln
cd /tmp
# Wordpress herunterladen und entpacken
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
# wp-config-sample.php kopieren als wp-config.php
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
# Upgrade Ordner erstellen
mkdir /tmp/wordpress/wp-content/upgrade
# WordPress Ordner kopieren in /var/www/html/wordpress
sudo cp -a /tmp/wordpress/. /var/www/html/wordpress
# Owner anpassen vom WordPress Ordner
sudo chown -R vagrant:www-data /var/www/html/wordpress
# Group ID setzen, damit Berechtigungen bei den neuen Ordnern bestehen bleiben
sudo find /var/www/html/wordpress -type d -exec chmod 2755 {} \;
# Berechtigung anpassen von wp-content, damit das Web Interface Änderungen an Themes und Plugins erstellen kann
sudo chmod g+w /var/www/html/wordpress/wp-content
sudo chmod -R g+w /var/www/html/wordpress/wp-content/themes
sudo chmod -R g+w /var/www/html/wordpress/wp-content/plugins
# wp-config.php kopieren
sudo cp /var/www/html/Fileshare/wp-config.php /var/www/html/wordpress/wp-config.php
# Apache neustarten
sudo systemctl restart apache2
# WP-CLI installieren und damit die WordPress Installation abschliessen
cd /tmp
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo -u vagrant -i -- wp core install --path=/var/www/html/wordpress --url=https://localhost:4343 --title="Meine WordPress Seite" --admin_name=wordpress --admin_email=wordpress@test.ch --admin_password=wordpress
# Firewall anpassen und Logging aktivieren
echo "y" | sudo ufw allow 80/tcp
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw allow 443/tcp
# echo "y" | sudo ufw deny out to any
echo "y" | sudo ufw enable
# Reverse Proxy einrichten
sudo a2enmod proxy proxy_html proxy_http
sudo cp /var/www/html/Fileshare/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart
sudo cp /var/www/html/Fileshare/apache2.conf /etc/apache2/apache2.conf  
# WordPress Datenbank URL auf HTTPS umstellen
#sudo mysql -u root -pvagrant -h 10.0.0.10 -d wordpress -e "UPDATE wp_options SET option_value = replace(option_value, 'http://localhost:8080', 'https://localhost:4343') WHERE option_name = 'home' OR option_name = 'siteurl';"
# SSL aktivieren
sudo a2ensite default-ssl.conf
sudo a2dissite 000-default.conf
sudo a2enmod ssl
sudo cp /var/www/html/Fileshare/ports.conf /etc/apache2/ports.conf
sudo service apache2 restart
# Authentisierung aktivieren
printf 'vagrant\nvagrant' | sudo htpasswd -c /etc/apache2/.htpasswd guest
sudo cp /var/www/html/Fileshare/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
sudo service apache2 restart
# Firewall aktivieren von db01
sudo ssh -o StrictHostKeychecking=no -l vagrant 10.0.0.10 "sudo ufw enable; yes"
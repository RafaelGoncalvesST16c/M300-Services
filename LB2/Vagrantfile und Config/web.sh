#!/bin/bash
#LAMP ohne MySQL installieren und konfigurieren

#DEBUG ON
set -o xtrace
#Packages vom lokalen Server holen
sudo apt-get update
#Packages herunterladen
sudo apt-get -y install apache2 php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd php-mysql php-mbstring php-xml libapache2-mod-php php-mcrypt libxml2-dev
#Apache Rewrite Mod aktivieren
sudo a2enmod rewrite
#Apache Config testen
sudo apache2ctl configtest
#Apache neustarten
sudo systemctl restart apache2
#Ordner wechseln
cd /tmp
#Wordpress herunterladen und entpacken
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
#wp-config-sample.php kopieren als wp-config.php
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
#Upgrade Ordner erstellen
mkdir /tmp/wordpress/wp-content/upgrade
#WordPress Ordner kopieren in /var/www/html/wordpress
sudo cp -a /tmp/wordpress/. /var/www/html/wordpress
#Owner anpassen vom WordPress Ordner
sudo chown -R vagrant:www-data /var/www/html/wordpress
#Group ID setzen, damit Berechtigungen bei den neuen Ordnern bestehen bleiben
sudo find /var/www/html/wordpress -type d -exec chmod 2755 {} \;
#Berechtigung anpassen von wp-content, damit das Web Interface Änderungen an Themes und Plugins erstellen kann
sudo chmod g+w /var/www/html/wordpress/wp-content
sudo chmod -R g+w /var/www/html/wordpress/wp-content/themes
sudo chmod -R g+w /var/www/html/wordpress/wp-content/plugins
#Apache neustarten
sudo systemctl restart apache2
#WP-CLI installieren und damit die WordPress Installation abschliessen
cd /tmp
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html/wordpress
#wp-config.php Variablen anpassen
echo "# ProxyPass Settings" >> /var/www/html/wordpress/wp-config.php
echo "#" >> /var/www/html/wordpress/wp-config.php
echo "# DO NOT REMOVE: overriding the following variables is" >> /var/www/html/wordpress/wp-config.php
echo "# required to ensure that any request /blog/* is handled" >> /var/www/html/wordpress/wp-config.php
echo "$_SERVER[‘REQUEST_URI’] = ‘/blog’ . $_SERVER[‘REQUEST_URI’];" >> /var/www/html/wordpress/wp-config.php
echo "$_SERVER[‘SCRIPT_NAME’] = ‘/blog’ . $_SERVER[‘SCRIPT_NAME’];" >> /var/www/html/wordpress/wp-config.php
echo "$_SERVER[‘PHP_SELF’] = ‘/blog’ . $_SERVER[‘PHP_SELF’];" >> /var/www/html/wordpress/wp-config.php
sudo -u vagrant wp config set DB_NAME 'wordpress'
sudo -u vagrant wp config set DB_USER 'wordpress'
sudo -u vagrant wp config set DB_PASSWORD 'wordpress'
sudo -u vagrant wp config set DB_HOST '10.0.0.11'
sudo -u vagrant wp config set FS_METHOD 'direct'
sudo -u vagrant wp config set AUTH_KEY '!ta+0sv-5fMp+IPQf-Hs1!|+Za5L|U42tn zG2Rk@5|>$7sVoX]pxaO(X#O2URa?'
sudo -u vagrant wp config set SECURE_AUTH_KEY 'w`R>IF1uiy5D5g,Au(`~+.]u>y)d|c+&70_65kdj_.iGO@~XRUarx6G#o)[_ *h<'
sudo -u vagrant wp config set LOGGED_IN_KEY 's6dL|+aq0$;5Y&0v5zEnYhn-!@{.nx&[-LDZ3:P.r-AxZ+YJBY!-oYSaB6Gv+F7?'
sudo -u vagrant wp config set NONCE_KEY 'riJpyN}K@{&~fD90|,kJcV6.19yGQ!+ja!&r6R1)qE3_5-eXA-osx{R7h~7V!jP~?'
sudo -u vagrant wp config set AUTH_SALT 'F<3?mr_bd!.^#+u n2T|t}_sqGP%;{$fCF@JkgfvWlkS$rZbZvn>-Cg*MNbd`E#R?'
sudo -u vagrant wp config set SECURE_AUTH_SALT 'ub?zbFw]ej$4_=Rf&w`. jVk&`[Gu&D!=hE}#N&t`hE|3uB,#(NEYg$@))x7/5j{'
sudo -u vagrant wp config set LOGGED_IN_SALT 'ChkK|55{no%U&rI+RfXzV6r-/i&l_(-{%xzFR@gipkwY@l;NY@pp0^vpT?-O?;Ec?'
sudo -u vagrant wp config set NONCE_SALT 'e+Qs.4qBJc4*}$d~u-Y:AWXA+$DIUYo nNDU ,*8(gi[3Z] v>l.>R3HG0||(`1:'
sudo -u vagrant -i -- wp core install --path=/var/www/html/wordpress --url=https://Test.ch --title="Meine WordPress Seite" --admin_name=wordpress --admin_email=wordpress@test.ch --admin_password=wordpress
#Firewall anpassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw allow 443/tcp
#Firewall Logging aktivieren
sudo ufw logging on
sudo ufw logging high
#Firewall aktivieren
echo "y" | sudo ufw enable
#Reverse Proxy einrichten
sudo a2enmod proxy proxy_html proxy_http
sudo rm /etc/apache2/sites-available/000-default.conf
cat <<EOF | sudo tee -a /etc/apache2/sites-available/000-default.conf
<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin info@Test.ch
		ServerName 10.0.0.12
		DocumentRoot /var/www/html/wordpress

		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		SSLEngine on

		SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
		SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

		<FilesMatch "\.(cgi|shtml|phtml|php)$">
		#SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>

		<Directory "/var/www/html/wordpress">
			AuthType Basic
			AuthName "Restricted Content"
			AuthUserFile /etc/apache2/.htpasswd
			Require valid-user
		</Directory>

		BrowserMatch "MSIE [2-6]" \
			nokeepalive ssl-unclean-shutdown \
			downgrade-1.0 force-response-1.0

		# Allgemeine Proxy Einstellungen
  	  	ProxyRequests Off
		<Proxy *>
			Order deny,allow
        	Allow from all
    	</Proxy>

    	# Weiterleitungen master
    	ProxyPass /master http://master
    	ProxyPassReverse /master http://master

	</VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
#Apache2 neustarten
sudo service apache2 restart
#Inhalt von der Apache2.conf anpassen
sudo sed '170i<Directory /var/www/html/wordpress>' /etc/apache2/apache2.conf
sudo sed '171i  AllowOverride All' /etc/apache2/apache2.conf
sudo sed '172i</Directory>' /etc/apache2/apache2.conf
sudo cp /var/www/html/Fileshare/apache2.conf /etc/apache2/apache2.conf  
# SSL aktivieren
sudo a2ensite default-ssl.conf
sudo a2dissite 000-default.conf
sudo a2enmod ssl
#Zugriff auf die Seite per HTTP verbieten
sudo sed -i 's/Listen 80/#Listen 80/g' /etc/apache2/ports.conf
#Apache2 neustarten
sudo service apache2 restart
# Authentisierung aktivieren
printf 'guest\nguest' | sudo htpasswd -c /etc/apache2/.htpasswd guest
#Default-ssl-conf Inhalt anpassen
sudo rm /etc/apache2/sites-available/default-ssl.conf
cat <<EOF | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin info@Test.ch
		ServerName 10.0.0.12
		DocumentRoot /var/www/html/wordpress

		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		SSLEngine on

		SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
		SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

		<FilesMatch "\.(cgi|shtml|phtml|php)$">
		#SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>

		<Directory "/var/www/html/wordpress">
			AuthType Basic
			AuthName "Restricted Content"
			AuthUserFile /etc/apache2/.htpasswd
			Require valid-user
		</Directory>

		BrowserMatch "MSIE [2-6]" \
			nokeepalive ssl-unclean-shutdown \
			downgrade-1.0 force-response-1.0

		# Allgemeine Proxy Einstellungen
    	ProxyRequests Off
    	<Proxy *>
        	Order deny,allow
        	Allow from all
 	   </Proxy>

	   SSLProxyEngine On
 	   # Weiterleitungen master
 	   ProxyPass /blog https://Test.ch/
  	   ProxyPassReverse /blog https://Test.ch/

	</VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
#Apache2 neustarten
sudo service apache2 restart
#Zertifikate, die von der CA signiert wurden, lokal kopieren vom Share aus
sudo cp /var/www/html/Fileshare/Test.ch.crt /home/vagrant/Test.ch.crt
sudo cp /var/www/html/Fileshare/Test.ch.key /home/vagrant/Test.ch.key
#Zertifikate, die von der CA signiert wurden, in der default-ssl.conf Datei hinzufügen
sudo sed -i 's,/etc/ssl/certs/ssl-cert-snakeoil.pem,/home/vagrant/Test.ch.crt,g' /etc/apache2/sites-available/default-ssl.conf
sudo sed -i 's,/etc/ssl/private/ssl-cert-snakeoil.key,/home/vagrant/Test.ch.key,g' /etc/apache2/sites-available/default-ssl.conf
#Apache2 neustarten
sudo service apache2 restart
#DNS eintragen
sudo sed -i 's/10.0.2.3/10.0.0.10/g' /etc/resolv.conf
#!/bin/bash

sudo apt update
sudo apt install apache2

sudo apt install mysql-server
sudo apt install php libapache2-mod-php php-mysql


conf="<IfModule mod_dir.c>
            DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
    </IfModule>"

sudo echo $conf > /etc/apache2/mods-enabled/dir.conf

sudo systemctl restart apache2

git clone https://github.com/rmsidebottom/WebAppSecurity.git /home/ubuntu/

sudo cp /home/ubuntu/WebAppSecurity/VulnerableWebApp/* /var/www/html/
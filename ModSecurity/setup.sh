#! /bin/bash

sudo apt-get install libapache2-mod-security2 -y
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sudo service apache2 reload

# modify modsecurity.conf and set SecRuleEngine to On in order to begin blocking attacks
# enable CRS or check that it is enabled, core rule set has SQLi and other owasp top 10 rules
# rules are located in /usr/share/modsecurity-crs
# in /etc/apache2/mods-enabled/security2.conf, ensure the following line is present and uncommented
# IncludeOptional /usr/share/modsecurity-crs/*.load
# the file owasp-crs.load in the modsec-crs folder contains the includes needed to run the owasp rules
# reload apache after this
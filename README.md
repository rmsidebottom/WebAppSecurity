# WebAppSecurity
Various web application security tools

1. [Vulnerable WebApp](#vulnerable-webapp)
    1. [LAMP Stack](#lamp-stack)
    2. [Virtual Machine Setup](#virtual-machine-setup)
    3. [mySQL Database Setup](#mysql-database-setup)
2. [ModSecurity](#modsecurity)

## Vulnerable WebApp
This is a basic web application built to run on apache. The repo contains just about everything needed to get the server up and running. The only thing that needs to be created is a text file containing the SQL database password. Optionally the database user can be changed from root to someone else (this is strongly recommended for anything that isn't purely a demo application that will be destroyed soon after creation).

### LAMP Stack
This webapp is designed using a LAMP stack to interface between all of its components. Through this, the site has been tested to be vulnerable to SQL injection. Other vulnerabilities have not been tested for.

### Virtual Machine Setup
To begin, a linux machine is needed. During testing of this, an EC2 instance from AWS ws used with the following settings:
- Ubnutu 20.04 LTS, ami-0885b1f6bd170450c 
- t2.micro
- default subnet, any availability zone
- Custom security group (allow HTTP in on port 80 from anywhere)

If you plan on configuring the machine via ssh, ensure SSH access is retained and that you have access to the key needed to authenticate.

Once the VM is up, connect to it and clone this repository. The first script that needs to be run in the `server_setup.sh` script. This script installs all the necessary components and should change the appropriate apache conf to increase the priority of PHP files. It should also copy all the webapp files to the directory `/var/www/html` which will allow access to the website.

### mySQL Database Setup
Once this is set up, next is running the `db_setup.sh` script. This is designed to set up the mySQL database from start to finish. Before running the setup script, create a text file called `secrets.txt` in the `/var/www/html` directory and the current one if you are running the setup script outside of the web directory. This will allow the webapp and the setup script to grab the password for mySQL. It should run the `mysql_secure_installation` script but if it doesn't run that first. 

- `./db_setup.sh setup` will run the `mysql_secure_installation` script
- `./db_setup.sh` will simply create the database, table, and add a couple entries

Upon completion, the table (called `logbook`) will look like the following:
| *id varchar(6)* | name varchar(50) | message varchar(28) |
| :---: | :---: | :---: |
| 123456 | Robert James | Nice app! |
| 098765 | Alfred Raymond | Submit works! | 

It will exist inside the database aptly named `webapp`.

With the database set up, the webapp should be fully funtioning. Now is the time to verify it's functionality. Add some entries to the database via the site and see if they display when searched for.

## ModSecurity
The website created previously is currently vulnerable to SQL injection (this is all that has been tested for). To test/demonstrate this, one can enter `' OR 1=1-- select * from logbook where name='` into the search box (under search for your entries). You should see that the next page will show everything that is currently in the table. That is not a good thing. 

One way to prevent this is to use a Web Application Firewall (WAF) such as ModSecurity. This stands before the application and will read the packet data to determine if there are any web attacks. It is configurable so it will only block attacks you have told it to block. By default it is configured only to alert on common attacks.

### Setup
To set it up, simply run the `setup.sh` script that exists in the ModSecurity folder. Since you already cloned this repository, it will already be there. 

After it runs, the following settings need to be changed and/or verified to begin blocking SQL injection attacks.
- Modify modsecurity.conf and set SecRuleEngine to On in order to begin blocking attacks 
    - Location: `/etc/modsecurity/modsecurity.conf`
- Enable CRS or check that it is enabled, core rule set has SQLi and other owasp top 10 rules
    - Rules are located in /usr/share/modsecurity-crs
    - In /etc/apache2/mods-enabled/security2.conf, ensure the following line is present and uncommented
        - `IncludeOptional /usr/share/modsecurity-crs/*.load`
    - The file owasp-crs.load in the modsec-crs folder contains the includes needed to run the owasp rules
- Reload apache after this, `sudo service apache2 reload`

Once this is complete, return to the site and verify that SQL injection has been blocked by re-entering the data from above. It should error out and return a 403 blocking you from viewing any data.

## References
I followed guides and directions from the following sites to create this:
- [LAMP Stack](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-ubuntu-18-04)
- [ModSecurity](https://github.com/SpiderLabs/ModSecurity)
- [ModSecurity Installation and setup](https://medium.com/@rishabhrrchauhan/cyber-security-prevent-sql-injection-using-modsecurity-f2d866e81dfd)


## Disclaimer
This is a vulnerable web application and mySQL database by design. It is not meant to be used in production environments as is. Even modsecurity and other WAFs will not be enough to prevent attacks when applications are created insecurely. This is merely meant to be something that can be created and spawned quickly to demonstrate the functionality of a WAF such as modsecurity. As such, it is advised that the instance be deleted in a timely manner unless it is hardened along with all of it's resources and servers.
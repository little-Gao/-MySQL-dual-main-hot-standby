#!/bin/bash
#Create mysql directories
if [ ! -d "/home/mysql/" ];then
    mkdir /home/mysql/
    echo "unzip mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz tar°ü..."
    tar -zxvf mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz
    echo "rename & Conversion directory"
    mv mysql-5.7.21-linux-glibc2.12-x86_64/ /home/mysql/mysql57 
	#Uninstall Mariadb from the system
	rpm -qa|grep mariadb && rpm -e --nodeps mariadb-libs-* && rpm -qa | grep mysql 
else
    if [ ! -d "/home/mysql/mysql57" ];then
        echo "unzip mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz tar°ü..."
        tar -zxvf mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz
        echo "rename & Conversion directory"
        mv mysql-5.7.21-linux-glibc2.12-x86_64/ /home/mysql/mysql57
		#Delete the my.cnf file in the etc directory
		rm /etc/my.cnf
		echo "complete base init evn"
    fi
fi

#Check whether mysql group and user exist, if not created, create mysql user group, create a user named mysql and join mysql user group
cat /etc/group | grep mysql &&  cat /etc/passwd | grep mysql &&  groupadd mysql &&  useradd -g mysql mysql &&  echo "123456" | passwd --stdin mysql 
echo "complete mysql create and group"

#Change the group and user to which you belong
chown -R mysql /home/mysql/mysql57/
chgrp -R mysql /home/mysql/mysql57/
mkdir /home/mysql/mysql57/data
chown -R mysql:mysql /home/mysql/mysql57/data
echo "complete Change the group and user to which you belong"

#Install and initialize
rm -r  /var/lock/subsys/mysql 
cp my.cnf /etc/my.cnf && /home/mysql/mysql57/bin/mysql_install_db --user=mysql --basedir=/home/mysql/mysql57/ --datadir=/home/mysql/mysql57/data/ && sed -i 's#^basedir=$#&/home/mysql/mysql57#' /home/mysql/mysql57/support-files/mysql.server && sed -i 's#^datadir=$#&/home/mysql/mysql57/data#' /home/mysql/mysql57/support-files/mysql.server && cp /home/mysql/mysql57/support-files/mysql.server /etc/init.d/mysqld && chmod 644 /etc/my.cnf && chmod +x /etc/init.d/mysqld && /etc/init.d/mysqld restart 
echo "complete Install and initialize"

#Set startup and environment variables
chkconfig --level 35 mysqld on
chkconfig --list mysqld
chmod +x /etc/rc.d/init.d/mysqld
chkconfig --add mysqld
chkconfig --list mysqld
service mysqld status
echo 'export PATH=$PATH:/var/mysql57/bin' >> /etc/profile
echo "complete Set startup and environment variables"
echo "complete mysql init and startup"
echo "complete mysql init and startup"
echo "You need to manually execute the command: source /etc/profile"
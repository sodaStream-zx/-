#!/bin/bash
#卸载旧的
kill -9 mysqld
rpm -qa|grep -i mysql
rpm -ev $(rpm -qa|grep -i mysql)
#安装
cd /usr/local/
wget http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm 
rpm -ivh mysql57-community-release-el7-8.noarch.rpm 
yum -y install mysql-server 
#默认配置文件路径： 
##配置文件：/etc/my.cnf 
#日志文件：/var/log/var/log/mysqld.log 
#服务启动脚本：/usr/lib/systemd/system/mysqld.service 
#socket文件：/var/run/mysqld/mysqld.pid
#配置  my.cnf        vim /etc/my.cnf
#添加:
# server_id = 1
# expire_logs_days = 3
#启动
#service mysqld restart
#临时密码
#grep "password" /var/log/mysqld.log
#mysql -u root
#修改密码
#alter user 'root'@'localhost' identified by 'Root!!2018';
# flush privileges 
# CREATE USER ‘root‘@‘%‘ IDENTIFIED BY ‘您的密码‘;
#grant all on *.* to 'root001'@'%' identified by 'Root@@'  with grant option;
#update mysql.user set authentication_string=password('root') where user='root' ;
#flush privileges;
#Zxx1994,.
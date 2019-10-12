#!/bin/bash
set -x
#/usr/bin/mysqladmin -u root password '123.coM&*('

function erase_mysql() {
#setenforce 0
#sed 's/SELINUX=.*$/SELINUX=disabled/' -i /etc/selinux/config
systemctl stop mysqld
systemctl disable mysqld
rpm -qa|grep mysql|xargs yum -y erase
yum -y erase mysql*
rm -rf /var/lib/mysql
rm -rf /etc/my.cnf
rm -rf /var/log/mysql*
rm -rf /data/mysql
rm -rf /var/run/mysql*
}

function install_mysql() {
echo "*   soft  nofile  32768" >> /etc/security/limits.conf
echo "*   hard  nofile  65535" >> /etc/security/limits.conf
#hostnamectl --static set-hostname mysqlrouter74
# selinux 配置
setenforce 0
sed 's/SELINUX=.*$/SELINUX=disabled/' -i /etc/selinux/config
#
server_id="$(ip address|grep 'inet[^6]'|grep -v '127.0.0.1/8'|awk -F'.' '{print $4}'|awk -F'/' '{print $1}')"

cat << EOF > /etc/yum.repos.d/mysql-community.repo
[mysql-connectors-community]
name=MySQL Connectors Community
baseurl=https://mirrors.tuna.tsinghua.edu.cn/mysql/yum/mysql-connectors-community-el7/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
[mysql-tools-community]
name=MySQL Tools Community
baseurl=https://mirrors.tuna.tsinghua.edu.cn/mysql/yum/mysql-tools-community-el7/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=https://mirrors.tuna.tsinghua.edu.cn/mysql/yum/mysql57-community-el7
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
EOF
sleep 2
yum -y remove mariadb* iptables-services && yum -y install firewalld 
yum -y install mysql-community-server
systemctl enable firewalld && systemctl start firewalld
firewall-cmd --permanent --zone=public --add-port={3306,13306,24901}/tcp
firewall-cmd --reload
data_dir="/data"
test -d "/data/mysql" || mkdir -p ${data_dir}/mysql
mv /var/lib/mysql ${data_dir}/
chown -R mysql:mysql ${data_dir}/mysql
cat << EOF > /etc/my.cnf
[client]
port = 3306
socket = /data/mysql/mysql.sock

[mysqld]
port = 3306
socket = /data/mysql/mysql.sock
log-error = /var/log/mysqld.log
pid-file = /var/run/mysqld/mysqld.pid
#basedir = /usr/sbin/mysqld
datadir = /data/mysql

character-set-server = utf8mb4

#user = mysql
#bind-address = *
default_storage_engine = InnoDB
max_allowed_packet = 512M
max_connections = 8000
open_files_limit = 12000
symbolic-links=1
key_buffer_size = 64M
connect_timeout = 3600
wait_timeout = 3600
interactive_timeout = 8000
explicit_defaults_for_timestamp = true
innodb_lock_wait_timeout = 180
skip_ssl

server_id=${server_id}
expire_logs_days = 30
log_bin = binlog
binlog_format = ROW

EOF
systemctl enable mysqld
systemctl restart mysqld
sleep 2
mysql_root_pass=$(grep 'temporary password' /var/log/mysqld.log|awk '{print $NF}')
echo "temporary password is ${mysql_root_pass}"
echo 'new password is 123.coM&*('
mysql_secure_installation
#配置数据库允许远连接
User="root"
Passwd="123.coM&*("
$(which mysql) -u${User} -p${Passwd} -e "GRANT ALL PRIVILEGES ON *.* TO zzyq@'%' identified by '123.coM&*(' WITH GRANT OPTION;GRANT RELOAD, SHUTDOWN, PROCESS, FILE, SUPER, REPLICATION SLAVE,REPLICATION CLIENT, CREATE USER ON *.* TO zzyq@'%' WITH GRANT OPTION;GRANT SELECT ON *.* TO zzyq@'%' WITH GRANT OPTION;"
$(which mysql) -u${User} -p${Passwd} -e "update mysql.user set Host='%' where User in ('root','zzyq'); flush privileges;"
$(which mysql) -u${User} -p${Passwd} -e "select Host,User from mysql.user\G;"

systemctl restart mysqld
}

#erase_mysql
sleep 2
install_mysql
set +x
exit

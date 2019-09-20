#!/bin/sh
PATH=$PATH:/bin:/usr/bin:/usr/sbin:/usr/local/edu/mysql/bin/
export PATH
DATE=`date +%Y%m%d`
cd /data/mysqlback/
rm -f *
mysqldump -x -uroot -p'password' -h 172.16.1.23 mysql > $DATE-mysql.sql
cd ..
tar zcf $DATE-mysqlbak.tgz mysqlback/
find /data/mysql_longbak -mtime +7 -type f |xargs rm -f
ftp -n -i -v 172.16.1.45 << FTPEND
user ftpuser password
bin
lcd /data/
cd /199/data/day/01/
mput $DATE-mysqlbak.tgz
bye
FTPEND
cd /data/
rm -f $DATE-mysqlbak.tgz

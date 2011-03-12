cd /tmp
ssh sarah.gudasoft.com "cd /tmp ; /usr/local/mongo/bin/mongodump --db re_production"
ssh sarah.gudasoft.com "cd /tmp ; /usr/bin/mysqldump -uroot -pmysqlodi re_production -r re_production.sql"

scp -r  sarah.gudasoft.com:/tmp/dump .
scp sarah.gudasoft.com:/tmp/re_production.sql .

mongo re_production --eval "db.dropDatabase()"
mongo re_development --eval "db.dropDatabase()"

mongorestore dump/
mongo --eval 'db.copyDatabase("re_production", "re_development");'

mysql -e "drop database re_development;"
mysql -e "create database re_development;"
mysql re_development < re_production.sql

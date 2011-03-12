#!/bin/bash
MONGO_HOME="$HOME/src/mongodb-linux-i686-1.4.2/"
MONGO_HOME="$HOME/src/mongodb-linux-i686-1.6.0/"

# starting mongo in production
echo "#################"
echo "# in production start with /usr/local/mongo/bin/mongod --dbpath /mysql_data/mongo_data --fork --logpath=/var/log/mongo.log -v"
echo "#################"

echo "Starting ....$MONGO_DIR/mongod --dbpath ~/re/data"
$MONGO_HOME/bin/mongod --dbpath ~/re/data --fork --logpath=log/mongo.log -vvvvv 

# --fork  --rest
export MONGO_HOME
echo "Run $MONGO_HOME/bin/mongo to start the console"

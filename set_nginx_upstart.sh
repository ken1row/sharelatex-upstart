#!/bin/bash

FILE="nginx.conf"

echo "description \"nginx http deamon\"" > $FILE
cat << 'EOS' >> $FILE
author      "me@localhost.jp"

start on (filesystem and net-device-up IFACE=lo)
stop on  shutdown

env DAEMON=/usr/sbin/nginx
env PIDFILE=/var/run/nginx.pid

respawn


pre-start exec $DAEMON -t
#post-stop exec $DAEMON -s stop

# Start Nginx
exec $DAEMON

EOS



sudo cp *.conf /etc/init/

#!/bin/bash

for serv in chat clsi docstore document-updater filestore real-time spelling tags template track-changes web
do
  FILE="sharelatex-${serv}.conf"

echo "description \"sharelatex-${serv}\"" > $FILE
cat << 'EOS' >> $FILE
author      "ShareLaTeX <team@sharelatex.com>"

start on (local-filesystems and net-device-up IFACE!=lo)
stop on shutdown

respawn

limit nofile 8192 8192

pre-start script
    mkdir -p /var/log/sharelatex
end script

script
EOS
echo "    SERVICE=${serv}" >> $FILE
cat << 'EOS' >> $FILE
    USER=sharelatex
    GROUP=sharelatex
    # You may need to replace this with an absolute 
    # path to Node.js if it's not in your system PATH.
    NODE=node
    SHARELATEX_CONFIG=/etc/sharelatex/settings.coffee
    # LATEX_PATH=/usr/local/texlive/2014/bin/x86_64-linux
    LATEX_PATH=/usr/bin

    echo $$ > /var/run/sharelatex-$SERVICE.pid
    chdir /var/www/sharelatex/$SERVICE
    exec sudo -u $USER -g $GROUP env SHARELATEX_CONFIG=$SHARELATEX_CONFIG NODE_ENV=production PATH=$PATH:$LATEX_PATH $NODE app.js >> /var/log/sharelatex/$SERVICE.log 2>&1
end script
EOS


done

sudo cp *.conf /etc/init/

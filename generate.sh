#!/usr/bin/env bash

SED=`which sed`
CURRENT_DIR=`dirname $0`

function main() { 

IFS=',' read -r -a dom <<< "$COM"

for d in "${dom[@]}"
do
IFS=' ' read -r DOMAIN SERVER <<< "$d"
gen
writ+=" -d $DOMAIN "
done

certbot --nginx --agree-tos -m "$EMAIL" -n $writ --expand 

}



function gen() { 

CONFIG="$DOMAIN.conf"

if [ -f "/etc/nginx/conf.d/$CONFIG" ]; then
echo "configuration for $DOMAIN already exists"
else 
echo "DOMAIN: $DOMAIN"
echo "SERVER: $SERVER"
cp /template.tpl /$CONFIG
$SED -i "s/{{DOMAIN}}/$DOMAIN/g" /$CONFIG
$SED -i "s/{{SERVER}}/$SERVER/g" /$CONFIG
mv /$CONFIG /etc/nginx/conf.d/
fi

}

main
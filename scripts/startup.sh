#!/usr/bin/env sh

set -euo pipefail

echo "Load default envoronments"
set -a 
source /etc/conf/defaults.env

echo "Render configuration using envsubst"
/usr/bin/envsubst \
    < /etc/conf/config.json.tpl \
    > ./config.json

echo "Start xray process"
exec /usr/bin/xray -config ./config.json
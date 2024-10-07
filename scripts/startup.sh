#!/usr/bin/env sh

set -euo pipefail

echo "Load default envoronments"
# to supress overriting dump existing env to file
env > .env
# read default
set -a 
source /etc/conf/defaults.env
# overrite its
source .env
rm -f .env

echo "Render configuration using envsubst"
/usr/bin/envsubst \
    < /etc/conf/config.json.tpl \
    > ./config.json

echo "Check config"
/usr/bin/sing-box check -c ./config.json

echo "Start sing-box process"
exec /usr/bin/sing-box run -c ./config.json
# vless-mikrotik

LESS container for RouterOS

Docker Hub: https://hub.docker.com/repository/docker/jsonguard/vless-mikrotik

Required env variables
```
/container envs
add name=vless key=REMOTE_ADDRESS value=XXX.vless-server.com
add name=vless key=USER_ID value=XXXX-XXXX-XXXX-XXXX
add name=vless key=STREAM_PUBLIC_KEY value=XXXX
add name=vless key=STREAM_SERVER_NAME value=yahoo.com
add name=vless key=STREAM_SHORT_ID value=XXXX
```

Additional env variables:
```
/container envs
add name=vless key=LOG_LEVEL value=warn

add name=vless key=LISTEN_HTTP value=8080
add name=vless key=LISTEN_SOCKS value=8090

add name=vless key=REMOTE_PORT value=443

add name=vless key=USER_ENCRYPTION value=none
add name=vless key=USER_FLOW value=xtls-rprx-vision
add name=vless key=STREAM_FINGERPRINT value=chrome
```
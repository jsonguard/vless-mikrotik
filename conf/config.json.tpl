{
  "log": {
    "loglevel": "${LOG_LEVEL}"
  },
   "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${LISTEN_HTTP},
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    },
    {
      "listen": "0.0.0.0",
      "port": ${LISTEN_SOCKS},
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true,
        "routeOnly": false
      },
      "tag": "socks"
    }
  ],
  "outbounds": [
    {
      "mux": {
        "concurrency": -1,
        "enabled": false,
        "xudpConcurrency": 8,
        "xudpProxyUDP443": ""
      },
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "${REMOTE_ADDRESS}",
            "port": ${REMOTE_PORT},
            "users": [
              {
                "encryption": "${USER_ENCRYPTION}",
                "flow": "${USER_FLOW}",
                "id": "${USER_ID}",
                "level": 8,
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "realitySettings": {
          "allowInsecure": false,
          "alpn": [
            "h2"
          ],
          "fingerprint": "${STREAM_FINGERPRINT}",
          "publicKey": "${STREAM_PUBLIC_KEY}",
          "serverName": "${STREAM_SERVER_NAME}",
          "shortId": "${STREAM_SHORT_ID}",
          "show": false,
          "spiderX": ""
        },
        "security": "reality",
        "tcpSettings": {
          "header": {
            "type": "none"
          }
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIP"
      },
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ]
}
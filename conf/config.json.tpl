{
  "log": {
    "level": "${LOG_LEVEL}"
  },
  "inbounds": [
    {
      "type": "tun",
      "inet4_address": "172.16.0.1/30",
      "auto_route": true,
      "strict_route": true,
      "sniff": true,
      "domain_strategy": "prefer_ipv4"
    }
  ],
  "outbounds": [
    {
      "type": "vless",
      "server": "${REMOTE_ADDRESS}",
      "server_port": ${REMOTE_PORT},
      "uuid": "${USER_ID}",
      "flow": "${USER_FLOW}",
      "tls": {
        "enabled": true,
        "server_name": "${STREAM_SERVER_NAME}",
        "utls": {
          "enabled": true,
          "fingerprint": "${STREAM_FINGERPRINT}"
        },
        "reality": {
          "enabled": true,
          "public_key": "${STREAM_PUBLIC_KEY}",
          "short_id": "${STREAM_SHORT_ID}"
        }
      },
      "multiplex": {
        "enabled": false,
        "protocol": "h2mux",
        "max_streams": 32
      },
      "packet_encoding": "xudp"
    }
  ]
}
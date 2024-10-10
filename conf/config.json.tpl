{
  "log": {
    "level": "${LOG_LEVEL}"
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "tun0",
      "inet4_address": ["${TUN_INTERNAL_NETWORK}"],
      "mtu": 1500,
      "auto_route": true,
      "strict_route": false,
      "stack": "system",
      "sniff": false,
      "inet4_route_exclude_address":
        [ 
          "192.168.0.0/16",
          "172.16.0.0/12"
        ],
      "domain_strategy": "ipv4_only"
    }
  ],
  "outbounds": [
    {
      "type": "vless",
      "tag": "vless-out",
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
        "max_streams": 128
      },
      "packet_encoding": "xudp"
    }
  ],
  "route": {
    "auto_detect_interface": true,
    "rules": [
      {
        "inbound": [
          "tun-in"
        ],
        "outbound": "vless-out"
      }
    ]
  }
}

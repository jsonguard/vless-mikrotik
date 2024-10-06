ARG XRAY_VERSION=24.9.30

FROM teddysun/xray:${XRAY_VERSION}

ARG WORKDIR=/runtime
ARG VLESS_USER=vless
ARG VLESS_GROUP=vless

# install utils to use to prepare config
RUN apk add envsubst --no-cache

COPY --chmod=755 conf /etc/conf
COPY --chmod=755 scripts /usr/local/scripts

# create user
RUN \
    addgroup -S ${VLESS_GROUP} &&\
    adduser -S ${VLESS_USER} -G ${VLESS_GROUP}

# create runtime directory
RUN \
    mkdir /${WORKDIR} &&\
    chown ${VLESS_USER}:${VLESS_GROUP} /${WORKDIR}

USER ${VLESS_USER}
WORKDIR ${WORKDIR}
ENTRYPOINT ["/bin/sh"]
CMD ["/usr/local/scripts/startup.sh"]

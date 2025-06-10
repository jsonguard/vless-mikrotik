# Public ARGs
ARG ALPINE_VERSION=3.20
ARG SING_BOX_VERSION=1.11.13

# ARGs for intenral usage
ARG SING_BOX_ARCH=${TARGETARCH}${TARGETVARIANT}
ARG SING_BOX_PATH=/sing-box

# use multi-sage build to get a sing-box binary
FROM alpine:${ALPINE_VERSION} as extracted

ARG SING_BOX_VERSION
ARG SING_BOX_ARCH
ARG SING_BOX_PATH

# Download and unpack sing-box distribution and place it to $SING_BOX_PATH
RUN \
    mkdir -p ./content &&\
    wget "https://github.com/SagerNet/sing-box/releases/download/v${SING_BOX_VERSION}/sing-box-${SING_BOX_VERSION}-linux-${SING_BOX_ARCH}.tar.gz" -O ./archive.tar.gz &&\
    tar -xzf archive.tar.gz -C ./content &&\
    find ./content -name sing-box -type f -exec mv '{}' ${SING_BOX_PATH} \;


# build target image
ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

ARG SING_BOX_PATH
ARG WORKDIR=/runtime

# prepare environment: install utils and create directories
RUN apk add envsubst --no-cache &&\
    mkdir -p /${WORKDIR}

COPY --from=extracted --chmod=777 ${SING_BOX_PATH} /usr/bin/sing-box
COPY --chmod=755 conf /etc/conf
COPY --chmod=755 scripts /usr/local/scripts

USER root
WORKDIR ${WORKDIR}
ENTRYPOINT ["/bin/sh"]
CMD ["/usr/local/scripts/startup.sh"]

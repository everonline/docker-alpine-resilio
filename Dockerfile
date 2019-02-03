FROM alpine:latest
MAINTAINER TD <tiago@everonline.eu>

ENV RESILIO_VERSION="2.6.3"
ENV DUMB_INIT_VERSION="1.2.2"
ENV GLIBC_VERSION="2.28-r0"

# Add User

RUN addgroup -g 1000 -S resilio && adduser -u 1000 -S resilio -G resilio

# Install Packages
RUN \
  echo "Upgrading OS Installing Dependencies" \
  && TMP_APK='curl tar ca-certificates' \
  && apk --update upgrade \
  && apk add $TMP_APK \

# Install Dumb Init
  && echo "Installing Dumb Init (${DUMB_INIT_VERSION})" \
  && >&2 echo "dumb-init_${DUMB_INIT_VERSION}_amd64" \
  && curl -#LOS https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 \
  && mv dumb-init_${DUMB_INIT_VERSION}_amd64 /usr/local/bin/dumb-init \
  && chmod +x /usr/local/bin/dumb-init \

# Install GLIBC

  && echo "Installing GLIBC (${GLIBC_VERSION})" \
  && >&2 echo "glibc-${GLIBC_VERSION}.apk" \
  && curl -#LOS https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && >&2 echo "sgerrand.rsa.pub" \
  && curl -#LS -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && apk add glibc-${GLIBC_VERSION}.apk \
  && rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk \

# Install Resilio
  && echo "Installing Resilio (${RESILIO_VERSION})" \
  && >&2 echo "resilio-sync_glibc23_x64.tar.gz" \
  && curl -#LS https://download-cdn.resilio.com/${RESILIO_VERSION}/linux-glibc-x64/resilio-sync_glibc23_x64.tar.gz | tar xzf - -C /usr/local/bin rslsync \
  && chmod +x /usr/local/bin/rslsync \

# Cleanup TMP
  && echo "Cleaning" \
  && apk del --purge $TMP_APK \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*

COPY entrypoint.sh /
COPY sync.conf /etc/
RUN chmod +x /entrypoint.sh
RUN chown resilio:resilio /etc/sync.conf

EXPOSE 8888 55555

VOLUME /mnt/sync
RUN chown -R resilio:resilio /mnt/sync/

USER resilio

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]
CMD ["--log", "--config", "/etc/sync.conf"]
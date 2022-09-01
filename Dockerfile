FROM alpine:latest
LABEL TD <tiago@everonline.eu>

ENV RESILIO_VERSION="2.7.3"
ENV GLIBC_VERSION="2.34-r0"

# Add User

RUN addgroup -g 1000 -S resilio && adduser -u 1000 -S resilio -G resilio

# Install Packages - Install Dumb Init - Install GLIBC - Install Resilio - Cleanup TMP

RUN \
  echo "Upgrading OS Installing Dependencies" \
  && TMP_APK='curl tar ca-certificates' \
  && apk --update upgrade \
  && apk add $TMP_APK \
  && echo "Installing Dumb Init" \
  && apk add dumb-init \
  && echo "Installing GLIBC (${GLIBC_VERSION})" \
  && >&2 echo "glibc-${GLIBC_VERSION}.apk" \
  && curl -#LOS https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && >&2 echo "sgerrand.rsa.pub" \
  && curl -#LS -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && apk add glibc-${GLIBC_VERSION}.apk \
  && rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk \
  && echo "Installing Resilio (${RESILIO_VERSION})" \
  && >&2 echo "resilio-sync_glibc23_x64.tar.gz" \
  && curl -#LS https://download-cdn.resilio.com/${RESILIO_VERSION}/linux-glibc-x64/resilio-sync_glibc23_x64.tar.gz | tar xzf - -C /usr/local/bin rslsync \
  && chmod +x /usr/local/bin/rslsync \
  && echo "Cleaning" \
  && apk del --purge $TMP_APK \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  && mkdir -p /mnt/sync

COPY entrypoint.sh /
COPY sync.conf /etc/

RUN \
  chmod +x /entrypoint.sh \
  && dos2unix /entrypoint.sh

EXPOSE 8888 55555
VOLUME [ "/mnt/sync" ]

RUN chown -R resilio:resilio /mnt/sync/

USER resilio

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]
CMD ["--log", "--config", "/mnt/sync/sync.conf"]

# Troubleshoot - Debug

#ENTRYPOINT ["tail", "-f", "/dev/null"]

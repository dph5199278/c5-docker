FROM scratch AS builder
ARG TARGETARCH
ADD ${TARGETARCH}/centos5.txz /

ENV BUILD_ARCH=$TARGETARCH

RUN echo "$BUILD_ARCH" > /etc/BUILD_ARCH

RUN rm -rf /usr/share/locale

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

FROM scratch
LABEL maintainer="Dely <dph5199278@163.com>" \
    name="CentOS Base Image" \
    license="GPLv2"

COPY --from=builder / /

ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]

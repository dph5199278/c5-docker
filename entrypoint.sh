#!/bin/sh

BUILD_ARCH=$(cat /etc/BUILD_ARCH 2>/dev/null || echo "unknown")

arch_cmd=""
case "$BUILD_ARCH" in
    amd64) command -v linux64 >/dev/null 2>&1 && arch_cmd="linux64" ;;
    386)   command -v linux32 >/dev/null 2>&1 && arch_cmd="linux32" ;;
esac
exec ${arch_cmd} /bin/sh -c "$*"

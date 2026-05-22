#!/bin/sh

BUILD_ARCH=$(cat /etc/BUILD_ARCH 2>/dev/null || echo "unknown")

# 防止无限递归：如果已经完成 setarch 转换，则直接执行用户命令
if [ -n "$SETARCH_DONE" ]; then
    exec "$@"
fi

case "$BUILD_ARCH" in
    amd64)
        if command -v linux64 >/dev/null 2>&1; then
            export SETARCH_DONE=1
            exec linux64 "$0" "$@"
        else
            exec "$@"
        fi
        ;;
    386)
        if command -v linux32 >/dev/null 2>&1; then
            export SETARCH_DONE=1
            exec linux32 "$0" "$@"
        else
            exec "$@"
        fi
        ;;
    *)
        # 其他架构直接运行
        exec "$@"
        ;;
esac

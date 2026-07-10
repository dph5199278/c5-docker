#!/bin/sh

BUILD_ARCH=$(cat /etc/BUILD_ARCH 2>/dev/null || echo "unknown")

# 最终执行命令的函数：用 /bin/sh 解析命令字符串
run_command() {
    # 兼容两种调用方式：
    # - SHELL ["/entrypoint.sh"]        -> 命令在 $1
    # - SHELL ["/entrypoint.sh", "-c"]  -> 命令在 $2
    if [ "$1" = "-c" ]; then
        shift
    fi
    exec /bin/sh -c "$*"
}

# 防止无限递归：如果已经完成 setarch 转换，则直接执行用户命令
if [ -n "$SETARCH_DONE" ]; then
    run_command "$@"
fi

case "$BUILD_ARCH" in
    amd64)
        if command -v linux64 >/dev/null 2>&1; then
            export SETARCH_DONE=1
            exec linux64 "$0" "$@"
        else
            run_command "$@"
        fi
        ;;
    386)
        if command -v linux32 >/dev/null 2>&1; then
            export SETARCH_DONE=1
            exec linux32 "$0" "$@"
        else
            run_command "$@"
        fi
        ;;
    *)
        # 其他架构直接运行
        run_command "$@"
        ;;
esac

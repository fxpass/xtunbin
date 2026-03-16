#!/bin/sh

# 1. 自动识别架构
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  BIN_ARCH="amd64" ;;
    aarch64|arm64) BIN_ARCH="arm64" ;;
    armv7l)  BIN_ARCH="armv7" ;;
    *) echo "❌ 不支持的架构: $ARCH"; exit 1 ;;
esac

# 2. 检查并下载二进制文件
if [ ! -f "/usr/local/bin/x-tunnel" ]; then
    echo "📥 正在下载 x-tunnel ($BIN_ARCH)..."
    curl -L "https://raw.githubusercontent.com/fxpass/xtunbin/main/bin/x-tunnel-linux-${BIN_ARCH}" -o /usr/local/bin/x-tunnel
    chmod +x /usr/local/bin/x-tunnel
fi

# 3. 运行程序（强制要求必填项）
echo "🚀 正在启动 x-tunnel..."

# 使用 :? 语法，如果变量未定义或为空，则打印错误并退出
exec /usr/local/bin/x-tunnel \
    -token "${XTUN_TOKEN:?请设置环境变量 XTUN_TOKEN}" \
    -f "${XTUN_SERVER:?请设置环境变量 XTUN_SERVER}" \
    -l "${XTUN_LISTEN:-socks5://0.0.0.0:40000,http://0.0.0.0:40001}" \
    -n "${XTUN_NODES:-3}" \
    -ip "${XTUN_IP_LIST:-ip.sb}" \
    -ips "${XTUN_IPS_COUNT:-4}" \
    -dns "${XTUN_DNS:-https://doh.pub/dns-query}" \
    -ech "${XTUN_ECH:-cloudflare-ech.com}" \
    ${XTUN_EXTRA_ARGS}

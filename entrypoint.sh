#!/bin/sh

echo "🚀 Starting x-tunnel with pre-baked binary..."

# 检查必填项
: "${XTUN_TOKEN:?请设置环境变量 XTUN_TOKEN}"
: "${XTUN_SERVER:?请设置环境变量 XTUN_SERVER}"
: "${XTUN_IP_LIST:?请设置环境变量 XTUN_IP_LIST}"

# 执行已经在镜像里的二进制文件
exec /usr/local/bin/x-tunnel \
    -token "${XTUN_TOKEN}" \
    -f "${XTUN_SERVER}" \
    -l "${XTUN_LISTEN}" \
    -n "${XTUN_NODES}" \
    -ip "${XTUN_IP_LIST}" \
    -ips "${XTUN_IPS_COUNT}" \
    -dns "${XTUN_DNS}" \
    -ech "${XTUN_ECH}" 

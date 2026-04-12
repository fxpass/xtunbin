FROM alpine:latest

# 声明我们要使用的自动变量
ARG TARGETARCH

# 安装必要工具 (确保包含 curl 用于健康检查)
RUN apk add --no-cache curl ca-certificates

# 根据构建架构下载对应的二进制文件
RUN case "${TARGETARCH}" in \
    "amd64")  BIN_ARCH="amd64"  ;; \
    "arm64")  BIN_ARCH="arm64"  ;; \
    "arm")    BIN_ARCH="armv7"  ;; \
    *) echo "Unsupported arch: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    echo "Building for $TARGETARCH, fetching $BIN_ARCH binary..." && \
    curl -L "https://raw.githubusercontent.com/fxpass/xtunbin/main/bin/x-tunnel-linux-${BIN_ARCH}" -o /usr/local/bin/x-tunnel && \
    chmod +x /usr/local/bin/x-tunnel

# 设置默认环境变量
ENV XTUN_TOKEN="" \
    XTUN_SERVER="" \
    XTUN_IP_LIST="" \
    XTUN_LISTEN="socks5://0.0.0.0:40000,http://0.0.0.0:40001" \
    XTUN_NODES="2" \
    XTUN_IPS_COUNT="4" \
    XTUN_DNS="https://1.1.1.1/dns-query" \
    XTUN_ECH="cloudflare-ech.com"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# --- 新增健康检查部分 ---
# 每 60 秒检查一次，连接超时 10 秒，连续失败 3 次认为异常
# 检查逻辑：通过容器本地的 HTTP 代理端口 (40001) 访问 Google 的 204 页面
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f -x http://127.0.0.1:40001 http://www.google.com/generate_204 || exit 1

EXPOSE 40000 40001

ENTRYPOINT ["/entrypoint.sh"]

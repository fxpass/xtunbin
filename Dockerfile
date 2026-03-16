FROM alpine:latest

# 声明我们要使用的自动变量
ARG TARGETARCH

# 安装必要工具
RUN apk add --no-cache curl ca-certificates

# 根据构建架构，在【构建阶段】下载对应的二进制文件
RUN case "${TARGETARCH}" in \
    "amd64")  BIN_ARCH="amd64"  ;; \
    "arm64")  BIN_ARCH="arm64"  ;; \
    "arm")    BIN_ARCH="armv7"  ;; \
    *) echo "Unsupported arch: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    echo "Building for $TARGETARCH, fetching $BIN_ARCH binary..." && \
    curl -L "https://raw.githubusercontent.com/fxpass/xtunbin/main/bin/x-tunnel-linux-${BIN_ARCH}" -o /usr/local/bin/x-tunnel && \
    chmod +x /usr/local/bin/x-tunnel

# 设置默认环境变量 (保持为空，强制用户输入)
ENV XTUN_TOKEN="" \
    XTUN_SERVER="" \
    XTUN_IP_LIST="" \
    XTUN_LISTEN="socks5://0.0.0.0:40000,http://0.0.0.0:40001" \
    XTUN_NODES="2" \
    XTUN_IPS_COUNT="4" \
    XTUN_DNS="https://doh.pub/dns-query" \
    XTUN_ECH="cloudflare-ech.com" \
    XTUN_EXTRA_ARGS=""

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 40000 40001

ENTRYPOINT ["/entrypoint.sh"]

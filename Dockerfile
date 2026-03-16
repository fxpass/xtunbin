FROM alpine:latest
RUN apk add --no-cache curl ca-certificates

# 仅保留基础运行环境的默认值，业务参数留空
ENV XTUN_TOKEN="" \
    XTUN_SERVER="" \
    XTUN_IP_LIST="" \
    XTUN_LISTEN="socks5://0.0.0.0:40000,http://0.0.0.0:40001" \
    XTUN_NODES="2" \
    XTUN_IPS_COUNT="4" \
    XTUN_DNS="https://doh.pub/dns-query" \
    XTUN_ECH="cloudflare-ech.com"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 40000 40001
ENTRYPOINT ["/entrypoint.sh"]

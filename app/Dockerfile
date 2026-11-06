FROM nginxinc/nginx-unprivileged:alpine
COPY index.html /usr/share/nginx/html/index.html
USER 101
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/ > /dev/null || exit 1

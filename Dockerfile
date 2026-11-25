FROM nginx:1.27-alpine
LABEL org.opencontainers.image.title="Codyssey Mission 1 Web"
LABEL org.opencontainers.image.description="Static web page for Docker and port-mapping practice"
COPY app/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

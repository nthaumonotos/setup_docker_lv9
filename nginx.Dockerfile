# Stage 1: Build
FROM docker.io/nginx:1.27.0-alpine3.19-slim AS build
ARG U_ID=1000
ARG G_ID=1000
RUN deluser nginx 2>/dev/null || true
RUN addgroup -g ${G_ID} nginx \
    && adduser -u ${U_ID} -G nginx -h /var/cache/nginx -s /sbin/nologin -D nginx
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
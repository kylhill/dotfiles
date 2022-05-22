FROM ubuntu/nginx:latest
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libnginx-mod-http-fancyindex \
  && DEBIAN_FRONTEND=noninteractive apt-get remove --purge --auto-remove -y \
  && rm -rf /var/lib/apt/lists/*

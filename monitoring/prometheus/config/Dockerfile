FROM prom/prometheus:latest

ADD prometheus.yml /etc/prometheus/
ADD alert.rules /etc/prometheus/

# Metadata params
ARG BUILD_DATE
ARG VCS_REF

# Metadata
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/jugatsu/microservices.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

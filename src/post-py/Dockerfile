FROM alpine:3.6

RUN apk --no-cache add python3 py3-pip \
  && pip3 install flask pymongo

WORKDIR /app
COPY requirements.txt /app

RUN pip3 install -r requirements.txt

COPY . /app/

ENV POST_DATABASE_HOST=post_db
ENV POST_DATABASE_PORT=27017
ENV POST_DATABASE=posts

# Metadata params
ARG BUILD_DATE
ARG VCS_REF

# Metadata
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/jugatsu/microservices.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

ENTRYPOINT ["python3", "post_app.py"]

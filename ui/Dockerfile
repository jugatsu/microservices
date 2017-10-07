FROM alpine:3.6
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

# install packages
RUN \
    apk --no-cache add ruby ruby-json; \
    apk --no-cache add --virtual .build-deps \
    build-base \
    ruby-dev \
    ruby-bundler \
  && bundle install \
  && gem cleanup \
  && rm -rf /usr/lib/ruby/gems/*/cache/* \
  \
  && apk del .build-deps

COPY . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

EXPOSE 9292/tcp

CMD ["puma"]

FROM alpine:3.6
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

RUN apk --no-cache add ruby ruby-json

ENV APP_HOME /app

# bundler environment variables
ENV BUNDLE_SILENCE_ROOT_WARNING=1

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

RUN apk --no-cache add --virtual .build-deps \
    build-base \
    ruby-dev \
    ruby-bundler \
  && bundle install \
  && gem cleanup \
  && rm -rf /usr/lib/ruby/gems/*/cache/* \
  && rm -rf /root/.bundle \
  \
  && apk del .build-deps

COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST=comment_db
ENV COMMENT_DATABASE=comments

CMD ["puma"]

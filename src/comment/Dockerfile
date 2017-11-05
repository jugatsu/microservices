FROM alpine:3.6

RUN apk --no-cache add ruby ruby-json tzdata

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

# Metadata params
ARG BUILD_DATE
ARG VCS_REF

# Metadata
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/jugatsu/microservices.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

CMD ["puma"]

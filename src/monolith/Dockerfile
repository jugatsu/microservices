FROM ubuntu:16.04
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com>"

# Install packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    mongodb-server \
    ruby-dev \
    ruby-full \
 && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler

# Fetch reddit-app code and install dependencies
RUN git clone -b monolith https://github.com/Artemmkin/reddit.git && \
    cd reddit && \
    bundle install

# Copy MongoDB config
COPY mongod.conf /etc/mongod.conf

# Copy reddit-app config
COPY db_config /reddit/db_config

# Copy startup script
COPY start.sh /start.sh

# Make startup script executable
RUN chmod 777 start.sh

EXPOSE 9292/tcp

CMD ["bash", "start.sh"]

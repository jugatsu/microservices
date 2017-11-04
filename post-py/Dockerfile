FROM alpine:3.6
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

RUN apk --no-cache add python3 py3-pip \
  && pip3 install flask pymongo

WORKDIR /app
COPY requirements.txt /app

RUN pip3 install -r requirements.txt

COPY . /app/

ENV POST_DATABASE_HOST=post_db
ENV POST_DATABASE_PORT=27017
ENV POST_DATABASE=posts

ENTRYPOINT ["python3", "post_app.py"]

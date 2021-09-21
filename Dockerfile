FROM alpine AS ecs-cli-downloader
MAINTAINER  Abraão Silva <abraaojs.dev@gmail.com>

RUN wget https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest -O /usr/local/bin/ecs-cli \
 && chmod 755 /usr/local/bin/ecs-cli

FROM python:3.7-alpine
MAINTAINER  Abraão Silva <abraaojs.dev@gmail.com>


RUN apk -v --no-cache --update add \
  nodejs \
  npm \
  python3 \
  ca-certificates \
  groff \
  jq \
  git \
  bash \
  zip \
  openssl 
  less \
  bash \
  make \
  curl \
  wget \
  && rm -rf /var/cache/apk/*

ENV AWSCLI_VERSION 1.20.45

RUN apk --update --no-cache add bash git \
 && apk --update --no-cache add --virtual .build-deps gcc musl-dev \
 && pip install --no-cache-dir awscli==$AWSCLI_VERSION aws-sam-cli \
 && apk del .build-deps --purge

COPY --from=ecs-cli-downloader /usr/local/bin/ecs-cli /usr/local/bin/ecs-cli

FROM ubuntu:latest
MAINTAINER  Abraão Silva <abraaojs.dev@gmail.com>
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential python3-venv python python-dev python-pip python-virtualenv && \
rm -rf /var/lib/apt/lists/*


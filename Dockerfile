FROM python:3.8.1-slim-buster
# We choose an Python image based on :
# - Debian 9, slim version
# - Python 3.8.1
# See here for all Python images : https://hub.docker.com/_/python

# Pipenv install
#
# Warnings : this container is explicitely configured for Dev environments
#  - pipfile --dev option
RUN apt update -y \
    && pip install --upgrade pip \
    && pip install pipenv

# Node setup
# 
# We must use a procedure that match with:
# - Debian 9, slim version
# - Node 12.14.1
# See on docker hub (https://hub.docker.com/_/node) for corresponding tag eg "12.14.1-buster-slim" which code is :
# https://github.com/nodejs/docker-node/blob/c31a071c73c5cc40dc662b75a4ee9f9fc23d6a39/12/stretch-slim/Dockerfile

ENV NODE_VERSION 12.14.1
ENV ARCH x64
WORKDIR /tmp
RUN buildDeps='xz-utils' \
    && apt install -y ca-certificates curl wget gnupg dirmngr $buildDeps --no-install-recommends \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && apt-get purge -y --auto-remove $buildDeps \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Tools install
RUN apt install -y zip

# Set Timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

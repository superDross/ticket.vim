FROM alpine:3.17.0

RUN mkdir -p /tests

WORKDIR /tests

RUN apk update && apk --no-cache add \
    autoconf \
    automake \
    bash \
    build-base \
    cmake \
    coreutils \
    curl \
    gettext-tiny-dev \
    git \
    libtool \
    libc6-compat \
    ninja \
    openssl \
    pkgconf \
    unzip \
    vim \
    wget

RUN git clone https://github.com/junegunn/vader.vim.git

COPY ./ /tests/
RUN mv /tests/test/test.vimrc ~/.vimrc

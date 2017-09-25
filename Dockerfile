FROM debian:9.1 AS base
LABEL maintainer="KenjiTakahashi <kenji.sx>"

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    zlib1g \
    libev4 \
    libssl1.0.2 \
    openssl \
    netcat \
    python-boto
RUN apt-get clean

FROM base

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    git \
    ca-certificates \
    ocaml \
    ocaml-findlib \
    make \
    m4 \
    camlp4 \
    camlp4-extra \
    libfindlib-ocaml-dev \
    zlib1g-dev \
    libev-dev \
    libpcre3-dev \
    libssl1.0-dev

RUN git clone https://github.com/whitehats/libres3 /tmp/libres3

WORKDIR /tmp/libres3
RUN git checkout 1.3
RUN ./configure \
    --prefix '/usr/local' \
    --localstatedir '/var'
RUN make
RUN make install
WORKDIR /

FROM base

COPY --from=1 /usr/local /usr/local
COPY run.sh /usr/local/bin

EXPOSE 80 443

VOLUME ["/usr/local/etc/ssl/certs"]

CMD ["/usr/local/bin/run.sh"]

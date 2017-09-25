**[Dockerized LibreS3](https://hub.docker.com/r/kdockerfiles/libres3/)**

**Head note:** This image is meant for easy automation, therefore it might not give you the same advanced configuration options as the [original Skylable one](https://hub.docker.com/r/skylable/libres3/).

# Usage

```sh
$ docker run kdockerfiles/libres3:1.3-1
```

## Available environment variables

```sh
$ docker run kdockerfiles/libres3:1.3-1 -e LIBRES3_HOST=my_libres3_cluster
```

Sets the LibreS3 host name (default: `libres3`).

```sh
$ docker run kdockerfiles/libres3:1.3-1 -e LIBRES3_VOLUME_SIZE=500G
```

Sets single volume size (default: 100G).

**Note:** This should be slightly smaller than the underlying `SX` single node storage size.

```sh
$ docker kdockerfiles/libres3:1.3-1 -e LIBRES3_REPLICAS=2
```

Sets the number of replicas (default: 1).

```sh
$ docker kdockerfiles/libres3:1.3-1 -e LIBRES3_BUCKET=my_bucket
```

If set, a bucket with given name will be created at start (default: No buckets created).

## Available ports

`80`: HTTP endpoint.

`443`: HTTPS endpoint.

*Note:* LibreS3 will only listen on one of these, depending on whether it's in secure or insecure mode.

## Available volumes

`/usr/local/etc/ssl/certs`: Exposes CA certificate that should be used by client connections.

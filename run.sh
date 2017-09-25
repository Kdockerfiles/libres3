#!/usr/bin/env sh
set -x

LIBRES3_HOST=${LIBRES3_HOST:-libres3}
LIBRES3_VOLUME_SIZE=${LIBRES3_VOLUME_SIZE:-100G}
LIBRES3_REPLICAS=${LIBRES3_REPLICAS:-1}

LIBRES3_CONF="/usr/local/etc/libres3/libres3.conf"

if [ ! -r "$LIBRES3_CONF" ]; then
    libres3_certgen "$LIBRES3_HOST"

    while ! nc -z sx 443; do
        echo "Waiting for SX to appear"
        sleep 1
    done

    libres3_setup --batch \
        --s3-host "$LIBRES3_HOST" \
        --s3-http-port 80 \
        --s3-https-port 443 \
        --default-volume-size "$LIBRES3_VOLUME_SIZE" \
        --default-replica "$LIBRES3_REPLICAS"

    # match nginx default
    echo "max_parallel=6144" >> $LIBRES3_CONF

    cp /usr/local/etc/libres3/libres3.sample.boto /root/.boto
    echo '\n[s3]\ncalling_format = boto.s3.connection.OrdinaryCallingFormat\n' >> /root/.boto

    if [ -n "$LIBRES3_BUCKET" ]; then
        /usr/local/sbin/libres3 start

        python -c "import boto; boto.connect_s3().create_bucket('$LIBRES3_BUCKET')"

        /usr/local/sbin/libres3 stop
    fi
fi

/usr/local/sbin/libres3_ocsigen --foreground

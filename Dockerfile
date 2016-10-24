FROM hope/base-alpine:3.4

MAINTAINER Sergey Sadovoi <sergey@hope.ua>

ENV \
    PHP_VERSION=5.6.26 \
    PHP_CONFIG=/etc/php5/php.ini \
    FPM_CONFIG=/etc/php5/php-fpm.conf

RUN \
    # Install
    apk add --no-cache \
        php5 \
        php5-cli \
        php5-fpm \
        php5-mysqli \
        php5-xml \
        php5-json \
        php5-pdo \
        php5-gd \
        php5-imagick \
        php5-opcache \
        php5-iconv \
        php5-curl \
        php5-ctype \
        php5-zlib \
        php5-pcntl && \

    # Configure
    sed -i -e "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g" ${FPM_CONFIG} && \
    sed -i -e "s/user = nobody/user = root/g" ${FPM_CONFIG} && \
    sed -i -e "s/group = nobody/group = root/g" ${FPM_CONFIG} && \

    sed -i -e "s/date.timezone = UTC/date.timezone = Europe\/Kiev/g" ${PHP_CONFIG} && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" ${PHP_CONFIG} && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 100M/g" ${PHP_CONFIG} && \

    # Log redirect
    ln -sf /dev/stdout /var/log/php-fpm.log

EXPOSE 9000

ENTRYPOINT ["php-fpm", "--nodaemonize", "--allow-to-run-as-root"]

FROM hope/base-alpine:3.5

ENV \
    PHP_VERSION=7.0.16 \
    PHP_CONFIG=/etc/php7/php.ini \
    FPM_CONFIG=/etc/php7/php-fpm.d/www.conf

RUN \
    # Install
    apk add --no-cache \
        php7 \
        php7-fpm \
        php7-mongodb@edge \
        php7-pdo \
        php7-mysqlnd \
        php7-mysqli \
        php7-xml \
        php7-dom \
        php7-json \
        php7-gd \
        php7-opcache \
        php7-iconv \
        php7-curl \
        php7-ctype \
        php7-zlib \
        php7-pcntl && \

    # Configure
    sed -i -e "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g" ${FPM_CONFIG} && \
    sed -i -e "s/user = nobody/user = root/g" ${FPM_CONFIG} && \
    sed -i -e "s/group = nobody/group = root/g" ${FPM_CONFIG} && \

    sed -i -e "s/;date.timezone =/date.timezone = Europe\/Kiev/g" ${PHP_CONFIG} && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" ${PHP_CONFIG} && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 100M/g" ${PHP_CONFIG} && \

    # Log redirect
    ln -sf /dev/stdout /var/log/php-fpm.log

EXPOSE 9000

ENTRYPOINT ["php-fpm7", "--nodaemonize", "--allow-to-run-as-root"]

FROM php:7.2-fpm

RUN apt-get update && \
    apt-get install -y libmcrypt-dev libicu-dev zlib1g-dev libpng-dev \
                       libsodium18 libsodium-dev libmemcached-dev \
                       libfreetype6-dev libjpeg62-turbo-dev \
                       git automake wget unzip libtool-bin \
                       apt-transport-https lsb-release ca-certificates

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install pdo_mysql intl zip gd opcache mysqli

RUN pecl install redis && \
    pecl install apcu-5.1.8 && \
    pecl install mcrypt-1.0.1 && \
    docker-php-ext-enable apcu redis mcrypt

# Install Composer Globally
RUN wget https://composer.github.io/installer.sig -P /tmp && \
    COMPOSER_SIGNATURE=$(cat /tmp/installer.sig) && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '${COMPOSER_SIGNATURE}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    rm /tmp/installer.sig && \
    php composer-setup.php && \
    unlink composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    composer global require "hirak/prestissimo:^0.3"

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY ./ini/pool.d/www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY ./ini/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
COPY ./ini/php.ini /usr/local/etc/php/conf.d

###
# Install dumb-init for entrypoint
ENV DUMBINIT_VERSION=1.2.0

ADD https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["php-fpm", "-y", "/etc/php/7.2/fpm/php-fpm.conf"]

RUN mkdir -p /srv/www/ /var/run/php7.2 /var/log/php && \
    chown -R www-data:www-data /var/run/php7.2 /var/log/php /srv/www && \
    chmod 775 /srv/www && \
    ln -sf /dev/stderr /var/log/php/php-fpm.log && \
    ln -sf /dev/stderr /var/log/php/www-error.log

# Install xdebug
RUN yes | pecl install xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini && \
#    echo "xdebug.remote_host=docker-host.dev" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo 'xdebug.file_link_format="phpstorm://open?url=file://%%f&line=%%l"' >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini && \
#    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_port=9090" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.max_nesting_level=10000" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/xdebug.ini

# Go to APP
WORKDIR /srv/www/

CMD ["php-fpm"]
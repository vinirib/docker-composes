FROM php:7.2-fpm
RUN buildDeps=" \
        libmcrypt-dev \
        default-libmysqlclient-dev \
        libjpeg-dev \
        libldap2-dev \
        libmemcachedutil2 \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
		libbz2-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt.so \
    && docker-php-ext-install bcmath bz2 calendar iconv json intl mbstring mysqli opcache pdo_mysql soap zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install bz2

RUN apt-get update \
	&& apt install apache2 memcached \
	php-memcached  netcat -y
RUN phpenmod memcached
RUN echo "<?php\n\t\
phpinfo();\n\
?>" >> /var/www/html/info.php	
 
COPY docker-entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh
EXPOSE 11211/tcp 11211/udp
EXPOSE 80
RUN /etc/init.d/apache2 start

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/bin/memcached"]
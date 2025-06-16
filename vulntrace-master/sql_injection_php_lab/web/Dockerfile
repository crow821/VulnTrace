FROM php:5.6-apache

RUN docker-php-ext-install mysqli

COPY index.php /var/www/html/index.php

# 确保 Apache 日志输出到标准文件
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
 && ln -sf /dev/stderr /var/log/apache2/error.log

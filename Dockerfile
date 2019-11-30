FROM alpine:latest

LABEL maintainer="Marco Gordillo <marcopgordillo@gmail.com>" \
  description="This example Dockerfile installs Apache." \
  version="1.0"

COPY start.sh /bootstrap

RUN apk update &&   apk upgrade &&   apk add --update apache2 ca-certificates openssl php7 php7-apache2 php7-curl php7-dom php7-exif php7-fileinfo php7-pecl-apcu php7-json php7-mbstring php7-mysqli php7-pdo_mysql php7-common php7-openssl php7-imagick php7-xml php7-zip php7-gd php7-iconv php7-mcrypt php7-simplexml php7-xmlreader php7-zlib php7-ssh2 php7-ftp php7-sockets php7-bcmath php7-opcache php7-phar php7-ctype php7-pdo php7-tokenizer php7-xmlwriter php7-session ghostscript imagemagick && \
      rm -rf /var/cache/apk/* && \
      deluser apache && delgroup www-data && deluser xfs && addgroup -S xfs && adduser -S xfs && \ 
      addgroup -S -g 33 www-data && \ 
      adduser -s /sbin/nologin -h /var/www -H -D -S -u 33 -G www-data www-data && \ 
      mkdir /etc/apache2/sites-enabled && mkdir /var/log/httpd && mkdir /var/www/cgi-bin && \ 
      ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf && \
      ln -sf /dev/stdout /var/log/httpd/access.log && ln -sf /dev/stder /var/log/httpd/error.log && \ 
      cd /tmp && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \ 
      php composer-setup.php --install-dir=/usr/local/bin --filename=composer && rm composer-setup.php && cd / && \ 
      chmod +x /bootstrap/start.sh

WORKDIR /var/www/html

EXPOSE 80/tcp

ENTRYPOINT ["/bootstrap/start.sh"]

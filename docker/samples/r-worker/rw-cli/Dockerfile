FROM wordpress:cli
USER root
RUN sed -i 's/:33:33/:1133:1133/;s/www-data:x:82:82/www-data:x:33:33/;s/\/home\/www-data/\/var\/www\/wp-cli/' /etc/passwd
RUN sed -i 's/:x:33/:x:1133/;s/www-data:x:82/www-data:x:33/' /etc/group
RUN mkdir -p /var/www/wp-cli
RUN chown -R www-data:www-data /var/www/wp-cli
RUN cp -pv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN sed -i 's/^memory_limit.*/memory_limit = 1G/' /usr/local/etc/php/php.ini
USER www-data:www-data


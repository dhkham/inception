FROM alpine:3.18

RUN apk update && \
    apk upgrade && \
    apk add curl bash mysql-client php82 php82-fpm php82-iconv php82-mysqli php82-phar dumb-init && \
    ln -s /usr/bin/php82 /usr/bin/php 
# Create a symbolic link to use 'php82' as 'php'

# Download WP-CLI and 'wait-for-it.sh', then make them executable
RUN curl -s -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --output /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /usr/local/bin/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it.sh

# Create a group named 'www-data', if it doesn't exist then exit with 0
RUN addgroup -g 82 -S www-data;     exit 0

# Create a user 'www-data' and add it to the group 'www-data'
RUN adduser -u 82 -D -S -G www-data www-data

# Copy PHP FPM configuration from the host OS to the image
COPY ./conf/www.conf /etc/php82/php-fpm.d/www.conf

# Create a directory for PHP processes to create sockets
RUN mkdir /run/php

# Copy the 'wordpress.sh' script from the host OS to the image and make it executable
COPY ./tools/wordpress.sh /usr/local/bin/wordpress.sh

RUN chmod +x /usr/local/bin/wordpress.sh && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Set the working directory in the Docker image to '/var/www/html'
WORKDIR /var/www/html

# Expose port 9000 for the PHP FastCGI Process Manager (FPM)
EXPOSE 9000

# Specify the command to run when the Docker container starts
ENTRYPOINT [ "/usr/bin/dumb-init", "--", "/usr/local/bin/wordpress.sh" ]
FROM alpine:3.16

ENV SERVER_NAME=localhost
ENV SERVER_ADMIN=admin@host.local
ENV RADIUS_ADDR=localhost
ENV RADIUS_PORT=1812
ENV RADIUS_SECRET=123456
ENV TZ=Europe/Berlin

#
VOLUME /svn
RUN apk --no-cache add tzdata bash apache2 apache2-utils apache2-webdav mod_dav_svn subversion apache-mod-auth-radius

RUN mkdir -p /run/apache2 &&\
#
mkdir -p /var/www/html/svn 
#
COPY 000-default.conf /etc/apache2/conf.d/
# wrong config file - has to be deletet
RUN rm /etc/apache2/conf.d/mod-auth-radius.conf
#
# Expose ports for http and custom protocol access
EXPOSE 80
#
#
#
CMD ["truncate", "-s", "0", "/etc/apache2/envvars"]
CMD ["echo", "export SERVER_NAME=$SERVER_NAME", ">>", "/etc/apache2/envvars"]
CMD ["echo", "export SERVER_ADMIN=$SERVER_NAME", ">>", "/etc/apache2/envvars"]
CMD ["echo", "export RADIUS_ADDR=$RADIUS_ADDR", ">>", "/etc/apache2/envvars"]
CMD ["echo", "export RADIUS_PORT=$RADIUS_PORT", ">>", "/etc/apache2/envvars"]
CMD ["echo", "export RADIUS_SECRET=$RADIUS_SECRET", ">>", "/etc/apache2/envvars"]

CMD ["httpd", "-D", "FOREGROUND"]

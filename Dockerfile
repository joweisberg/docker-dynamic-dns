FROM alpine
MAINTAINER Jonathan Weisberg <jo.weisberg@gmail.com>

RUN apk --no-cache --update add bash curl

WORKDIR /root

COPY dyndns.sh /root/dyndns.sh
COPY healthcheck /usr/bin/healthcheck
RUN chmod +x /usr/bin/healthcheck

CMD ["/bin/bash", "/root/dyndns.sh"]
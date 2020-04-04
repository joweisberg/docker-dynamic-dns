FROM alpine
MAINTAINER Jonathan Weisberg <jo.weisberg@gmail.com>

RUN apk update && apk add bash wget

WORKDIR /root

COPY dyndns.sh /root/dyndns.sh
RUN chmod +x /root/dyndns.sh

CMD ["/bin/bash", "/root/dyndns.sh"]
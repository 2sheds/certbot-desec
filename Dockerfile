FROM alpine:latest
MAINTAINER Oleg Kurapov (@kurapov)

ENV UID="1000"
ENV GUID="1000"

VOLUME /certs
VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt
WORKDIR /scripts

COPY ./letsencrypt-autorenew-docker/scripts/run_certbot.sh . 
COPY ./certbot-hook/hook.sh .
COPY dedynauth .dedynauth
COPY entrypoint.sh .
RUN chmod +x *.sh && \
	apk add --no-cache openssl curl bind-tools bash ca-certificates certbot && \
	rm -rf /tmp/* /var/tmp/*


ENTRYPOINT ["./entrypoint.sh"]

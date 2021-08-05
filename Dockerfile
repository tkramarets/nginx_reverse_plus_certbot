FROM nginx:1.20-alpine
MAINTAINER Taras Kramarets <tkramarets@gmail.com>
RUN apk --no-cache add certbot-nginx supervisor && mkdir /etc/letsencrypt && mkdir /var/log/supervisor/ && rm -rf /var/cache/apk/*
COPY supervisord.conf /etc/supervisord.conf
COPY supervisor.d/ /etc/supervisor/conf.d
RUN (2>/dev/null crontab -l ; echo "0 3 * * * /usr/bin/certbot renew") | crontab -
RUN (2>/dev/null crontab -l ; echo "0 5 * * * nginx -s reload") | crontab -
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
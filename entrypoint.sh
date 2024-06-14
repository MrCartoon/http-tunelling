#!/bin/bash

# Create necessary directories
mkdir -p /var/www/certbot

# Substitute environment variables in nginx.conf.template
envsubst '$HOST' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
echo "dns_cloudflare_api_token = ${CLOUDFLARE_TOKEN}" > /etc/letsencrypt/cloudflare.ini

# Obtain initial certificate
if [ ! -d "/etc/letsencrypt/live/$HOST" ]; then
  certbot certonly -d "*.$HOST" --non-interactive --agree-tos --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60 --email $LETSENCRYPT_EMAIL
fi

# Start crond in the background
crond &

# Keep Nginx running in the foreground
nginx -g 'daemon off;'

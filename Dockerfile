# Use the official Nginx image as a base
FROM nginx:latest

# Install Certbot and cron
RUN apt-get update && \
    apt-get install -y certbot python3-certbot-nginx cron gettext-base python3-certbot-dns-cloudflare && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -o /etc/letsencrypt/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf

# Copy custom Nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Create a volume for Let's Encrypt certificates
VOLUME /etc/letsencrypt

# Create a volume for the webroot
VOLUME /var/www/certbot

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define environment variable
ENV HOST example.com

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

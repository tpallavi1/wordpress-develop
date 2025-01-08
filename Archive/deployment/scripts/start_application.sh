#!/bin/bash
# Restart Apache to apply any configuration changes
systemctl restart httpd

# Clear PHP opcache if installed
if [ -f /etc/php.d/10-opcache.ini ]; then
    systemctl restart php-fpm
fi

# Verify Apache is running
if ! systemctl is-active --quiet httpd; then
    echo "Error: Apache failed to start"
    exit 1
fi

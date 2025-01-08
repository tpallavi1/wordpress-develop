#!/bin/bash
# Check if Apache is running
if ! systemctl is-active --quiet httpd; then
    echo "Error: Apache is not running"
    exit 1
fi

# Check if we can access WordPress files
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    echo "Error: WordPress configuration file not found"
    exit 1
fi

# Verify PHP is working
if ! curl -s http://localhost/wordpress/wp-admin/install.php | grep -q "WordPress"; then
    echo "Error: WordPress installation page is not accessible"
    exit 1
fi

echo "Service validation completed successfully"
exit 0

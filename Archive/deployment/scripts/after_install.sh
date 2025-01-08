#!/bin/bash
# Set proper permissions
chown -R apache:apache /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# Configure SELinux if enabled
if [ -x "$(command -v semanage)" ]; then
    semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
    restorecon -Rv /var/www/html
fi

# Get stack name from instance tags
STACK_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=aws:cloudformation:stack-name" --query 'Tags[0].Value' --output text)

# Get database credentials from Secrets Manager
DB_SECRET=$(aws secretsmanager get-secret-value --secret-id wordpress-secrets-${STACK_NAME} --query SecretString --output text)
DB_PASSWORD=$(echo $DB_SECRET | jq -r .DBPassword)

# Get RDS endpoint
RDS_INFO=$(aws rds describe-db-instances --db-instance-identifier ${STACK_NAME} --query 'DBInstances[0].Endpoint')
DB_HOST=$(echo $RDS_INFO | jq -r .Address)

# Test database connection
if mysql -h "$DB_HOST" -u "wpuser" -p"$DB_PASSWORD" "wordpressdb" -e "SELECT 1;" > /dev/null 2>&1; then
    echo "Database connection successful"
else
    echo "Error: Could not connect to database"
    exit 1
fi

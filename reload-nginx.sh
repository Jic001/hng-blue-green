#!/bin/bash
set -e

# Generate nginx.conf from template
envsubst '$ACTIVE_POOL' < nginx.conf.template > nginx.conf

echo "Reloading Nginx..."

# If Nginx is already running, reload it; otherwise, start it in foreground
if pgrep nginx >/dev/null 2>&1; then
    # Reload gracefully
    nginx -s reload
else
    # Start Nginx in the foreground (needed for Docker container)
    nginx -g 'daemon off;'
fi

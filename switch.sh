#!/bin/bash
# Blue-Green deployment switch script

NGINX_CONTAINER="nginx"
ACTIVE_COLOR=$(sudo docker exec $NGINX_CONTAINER sh -c "grep -o 'app_blue' /etc/nginx/nginx.conf | head -n 1")

if [[ "$ACTIVE_COLOR" == "app_blue" ]]; then
  echo "Switching from BLUE to GREEN..."
  sudo docker exec $NGINX_CONTAINER sh -c "sed -i 's/app_blue/app_green/g' /etc/nginx/nginx.conf"
else
  echo "Switching from GREEN to BLUE..."
  sudo docker exec $NGINX_CONTAINER sh -c "sed -i 's/app_green/app_blue/g' /etc/nginx/nginx.conf"
fi

sudo docker exec $NGINX_CONTAINER nginx -s reload
echo "✅ Switched successfully!"

#!/bin/bash
DEVBOX_IP=$(docker-machine ip)
DISCOVERY_ID=$(docker run --rm swarm create)

sed -e "s/\${DEVBOX_IP}/$DEVBOX_IP/" -e "s/\${DISCOVERY_ID}/$DISCOVERY_ID/" docker-compose.yml.template > docker-compose.yml

echo "Docker host: https://$DEVBOX_IP:2376"
echo "Swarm master: https://$DEVBOX_IP:3375"
echo "Discovery token: $DISCOVERY_ID"
echo ""
echo "You're now ready to start your dev cluster:"
echo "$ docker-compose up"

#!/bin/bash
ACTIVE_MACHINE=$(docker-machine active)
DEVBOX_IP=$(docker-machine ip)

if [ -n "${http_proxy+1}" ]; then
    echo -e "export HTTP_PROXY=$http_proxy\nexport HTTPS_PROXY=$http_proxy\nexport http_proxy=$http_proxy\nexport https_proxy=$http_proxy" | docker-machine ssh $ACTIVE_MACHINE 'sudo tee -a /var/lib/boot2docker/profile'
    docker-machine ssh $ACTIVE_MACHINE 'sudo /etc/init.d/docker stop'
    sleep 1
    docker-machine ssh $ACTIVE_MACHINE 'sudo /etc/init.d/docker start'
    sleep 3
    export NO_PROXY="$NO_PROXY,$(docker-machine ip)"
    export no_proxy="$no_proxy,$(docker-machine ip)"
    echo -e "export NO_PROXY=\"$NO_PROXY\"\nexport no_proxy=\"$no_proxy\""
fi
DISCOVERY_ID=$(docker run -e http_proxy -e https_proxy -e no_proxy --rm swarm create)

docker-machine ssh $ACTIVE_MACHINE 'sudo mkdir /certs && chmod -R 777 /certs'
cat $DOCKER_CERT_PATH/cert.pem | docker-machine ssh $ACTIVE_MACHINE 'cat > /certs/cert.pem'
cat $DOCKER_CERT_PATH/key.pem | docker-machine ssh $ACTIVE_MACHINE 'cat > /certs/key.pem'
cat $DOCKER_CERT_PATH/ca.pem | docker-machine ssh $ACTIVE_MACHINE 'cat > /certs/ca.pem'

sed -e "s/\${DEVBOX_IP}/$DEVBOX_IP/" -e "s/\${DISCOVERY_ID}/$DISCOVERY_ID/" docker-compose.yml.template > docker-compose.yml

echo "# Docker host: https://$DEVBOX_IP:2376"
echo "# Swarm master: https://$DEVBOX_IP:3375"
echo "# Discovery token: $DISCOVERY_ID"
echo "#"
echo "# You're now ready to start your dev cluster:"
echo "# $ docker-compose up"

#!/bin/bash
echo "DEVBOX_IP="$(docker-machine ip shipyard-devbox) > env
echo "DISCOVERY_ID="$(docker run --rm swarm create) >> env

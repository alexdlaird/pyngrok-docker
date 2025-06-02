#!/usr/bin/env bash

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"

if [[ "$DOCKER_ACCESS_TOKEN" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set" & exit 1 ; fi

echo "$DOCKER_ACCESS_TOKEN" | docker login --username "$DOCKER_USERNAME" --password-stdin

for PYTHON_VERSION in 3.8 3.9 3.10 3.11 3.12 3.13; do
  for DISTRO in bookworm bullseye alpine; do
    docker push "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION-$DISTRO"
  done
done

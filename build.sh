#!/usr/bin/env bash

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"
LINUX_PLATFORMS="linux/386,linux/amd64,linux/arm,linux/arm64,linux/ppc64le,linux/s390x"

for PYTHON_VERSION in 3.8 3.9 3.10 3.11 3.12 3.13; do
  for DISTRO in bookworm bullseye alpine; do
    docker buildx build \
        -t "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION-$DISTRO" \
        --platform=$LINUX_PLATFORMS \
        linux/$PYTHON_VERSION/$DISTRO

    # Tag a default distro, for when none is given
    if [ $DISTRO == "bookworm" ]; then
      IMAGE_ID=$(docker images -q --format '{{.ID}}' | head -1)
      docker tag "$IMAGE_ID" "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION"

      if [ $PYTHON_VERSION == "3.13" ]; then
        docker tag "$IMAGE_ID" "$DOCKER_USERNAME/pyngrok"
      fi
    fi
  done

  # Tag  default Python version, for when none is given
  if [ $PYTHON_VERSION == "3.13" ]; then
    IMAGE_ID=$(docker images -q --format '{{.ID}}' | head -1)
    docker tag "$IMAGE_ID" "$DOCKER_USERNAME/pyngrok:$DISTRO"
  fi
done

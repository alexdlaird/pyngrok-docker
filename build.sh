#!/usr/bin/env bash

set -o errexit

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"

if [[ "$PYTHON_VERSION" == "" ]]; then echo "PYTHON_VERSION is not set" & exit 1 ; fi
if [[ "$DISTRO" == "" ]]; then echo "DISTRO is not set" & exit 1 ; fi
if [[ "$PLATFORM" == "" ]]; then echo "PLATFORM is not set" & exit 1 ; fi
if [[ "$PUBLISH" != "" ]]; then
  if [[ "$DOCKER_ACCESS_TOKEN" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set" & exit 1 ; fi
fi

docker buildx build \
    -t "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION-$DISTRO" \
    --build-arg "PYTHON_VERSION=$PYTHON_VERSION" \
    --build-arg "DISTRO=$DISTRO" \
    --platform="$PLATFORM" \
    "$DIR"

# Add special tags for default images
if [[ "$PYTHON_VERSION" == "3.13" ]]; then
  IMAGE_ID=$(docker images -q --format '{{.ID}}' | head -1)

  docker tag "$IMAGE_ID" "$DOCKER_USERNAME/pyngrok:$DISTRO"

  if [[ "$DISTRO" == "bookworm" ]]; then
    docker tag "$IMAGE_ID" "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION"
    docker tag "$IMAGE_ID" "$DOCKER_USERNAME/pyngrok:latest"
  fi
fi

if [[ "$PUBLISH" != "" ]]; then
  echo "$DOCKER_ACCESS_TOKEN" | docker login --username "$DOCKER_USERNAME" --password-stdin

  docker push "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION-$DISTRO"
fi

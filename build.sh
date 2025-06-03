#!/usr/bin/env bash

set -o errexit

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"

if [[ "$PYTHON_VERSION" == "" ]]; then echo "PYTHON_VERSION is not set" & exit 1 ; fi
if [[ "$DISTRO" == "" ]]; then echo "DISTRO is not set" & exit 1 ; fi
if [[ "$PLATFORM" == "" ]]; then echo "PLATFORM is not set" & exit 1 ; fi

PUBLISH_ARGS=""
if [[ "$PUBLISH" != "" ]]; then
  if [[ "$DOCKER_ACCESS_TOKEN" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set" & exit 1 ; fi
else
  echo "$DOCKER_ACCESS_TOKEN" | docker login --username "$DOCKER_USERNAME" --password-stdin

  PUBLISH_ARGS+=" --push"
fi

# Build tag aliases
ADDITIONAL_TAGS=""
if [[ "$PYTHON_VERSION" == "3.13" ]]; then
  ADDITIONAL_TAGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO"

  if [[ "$DISTRO" == "bookworm" ]]; then
    ADDITIONAL_TAGS+=" -t $DOCKER_USERNAME/pyngrok:$PYTHON_VERSION"
    ADDITIONAL_TAGS+=" -t $DOCKER_USERNAME/pyngrok:latest"
  fi
fi

# shellcheck disable=SC2086
docker buildx build \
    -t "$DOCKER_USERNAME/pyngrok:$PYTHON_VERSION-$DISTRO" \
    $ADDITIONAL_TAGS \
    --build-arg "PYTHON_VERSION=$PYTHON_VERSION" \
    --build-arg "DISTRO=$DISTRO" \
    --platform="$PLATFORM" \
    $PUBLISH_ARGS \
    .

#!/usr/bin/env bash

set -o errexit

PYTHON_BIN=${PYTHON_BIN:-python}
GREP_BIN=${GREP_BIN:-grep}

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"

if [[ "$PYNGROK_VERSION" == "" ]]; then
  PYNGROK_VERSION=$($PYTHON_BIN -m pip index versions pyngrok | $GREP_BIN -oP 'Available versions: \K[0-9\.]*')
  echo "PYNGROK_VERSION not set, using latest $PYNGROK_VERSION"
fi
if [[ "$PYTHON_VERSION" == "" ]]; then echo "PYTHON_VERSION is not set" & exit 1 ; fi
if [[ "$DISTRO" == "" ]]; then echo "DISTRO is not set" & exit 1 ; fi
if [[ "$PLATFORM" == "" ]]; then echo "PLATFORM is not set" & exit 1 ; fi

PUBLISH_ARGS=""
if [[ "$PUBLISH" == "true" ]]; then
  if [[ "$DOCKER_ACCESS_TOKEN" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set, required when PUBLISH=true" & exit 1 ; fi

  echo "$DOCKER_ACCESS_TOKEN" | docker login --username "$DOCKER_USERNAME" --password-stdin

  PUBLISH_ARGS+=" --push"

  echo "--> PUBLISH=true, so the built image for $DEFAULT_TAG and tags will be published to Docker Hub with version $PYNGROK_VERSION."
fi

# Build tag aliases
DEFAULT_TAG="$DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-$PYNGROK_VERSION"
ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-latest"
ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO"
if [[ "$PYTHON_VERSION" == "3.13" ]]; then
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-$PYNGROK_VERSION"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-latest"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO"

  if [[ "$DISTRO" == "slim-bookworm" ]]; then
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$PYNGROK_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-latest"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION"

    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$PYNGROK_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:latest"
  fi
fi

echo "--> Build will start for PYTHON_VERSION=$PYTHON_VERSION, DISTRO=$DISTRO, PLATFORM=$PLATFORM, PYNGROK_VERSION=$PYNGROK_VERSION."
echo "--> Build will be tagged with -t $DEFAULT_TAG $ADDITIONAL_TAG_ARGS"

# shellcheck disable=SC2086
docker buildx build \
    -t "$DEFAULT_TAG" \
    $ADDITIONAL_TAG_ARGS \
    --build-arg "PYTHON_VERSION=$PYTHON_VERSION" \
    --build-arg "DISTRO=$DISTRO" \
    --build-arg "PYNGROK_VERSION=$PYNGROK_VERSION" \
    --platform="$PLATFORM" \
    $PUBLISH_ARGS \
    .

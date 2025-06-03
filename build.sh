#!/usr/bin/env bash

set -o errexit

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"

if [[ "$VERSION" == "" ]]; then echo "VERSION is not set" & exit 1 ; fi
if [[ "$PYTHON_VERSION" == "" ]]; then echo "PYTHON_VERSION is not set" & exit 1 ; fi
if [[ "$DISTRO" == "" ]]; then echo "DISTRO is not set" & exit 1 ; fi
if [[ "$PLATFORM" == "" ]]; then echo "PLATFORM is not set" & exit 1 ; fi

PUBLISH_ARGS=""
if [[ "$PUBLISH" != "" ]]; then
  if [[ "$DOCKER_ACCESS_TOKEN" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set" & exit 1 ; fi
else
  echo "$DOCKER_ACCESS_TOKEN" | docker login --username "$DOCKER_USERNAME" --password-stdin

  PUBLISH_ARGS+=" --push"

  echo "PUBLISH is set, so the build image and tags will be pushed to Docker Hub with version $VERSION."
fi

# Build tag aliases
DEFAULT_TAG="$DOCKER_USERNAME/pyngrok:$VERSION-py$PYTHON_VERSION-$DISTRO"
ADDITIONAL_TAG_ARGS=""
if [[ "$PYTHON_VERSION" == "3.13" ]]; then
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$VERSION-$DISTRO"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO"

  if [[ "$DISTRO" == "slim-bookworm" ]]; then
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$VERSION-py$PYTHON_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION"

    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok"
  fi
fi

echo "--> Build will start for PYTHON_VERSION=$PYTHON_VERSION, DISTRO=$DISTRO, PLATFORM=$PLATFORM, VERSION=$VERSION."
echo "--> Build will be tagged with -t $DEFAULT_TAG $ADDITIONAL_TAG_ARGS"

# shellcheck disable=SC2086
docker buildx build \
    -t "$DEFAULT_TAG" \
    $ADDITIONAL_TAG_ARGS \
    --build-arg "PYTHON_VERSION=$PYTHON_VERSION" \
    --build-arg "DISTRO=$DISTRO" \
    --platform="$PLATFORM" \
    $PUBLISH_ARGS \
    .

if [[ "$PUBLISH" != "" ]]; then
  echo "--> PUBLISH was set, so the built image for $DEFAULT_TAG and additional tags were also published to Docker Hub."
fi

#!/usr/bin/env bash

set -o errexit

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
PYTHON_BIN=${PYTHON_BIN:-python}
GREP_BIN=${GREP_BIN:-grep}
DEFAULT_TAG_SUFFIX=${DEFAULT_TAG_SUFFIX:-}

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"

if [[ "$VERSION" == "" ]]; then
  VERSION=$(./$SCRIPT_DIR/pypi-latest.sh)
  echo "VERSION not set, using latest $VERSION"
fi
# shellcheck disable=SC2046
if [ $(echo "$VERSION" | $GREP_BIN -o "\." | $GREP_BIN -c "\.") != 3 ]; then
  echo "VERSION must have four numbers, be of format x.y.z.a" & exit 1
fi
if [[ "$PYTHON_VERSION" == "" ]]; then echo "PYTHON_VERSION is not set" & exit 1 ; fi
if [[ "$DISTRO" == "" ]]; then echo "DISTRO is not set" & exit 1 ; fi
if [[ "$PLATFORM" == "" ]]; then echo "PLATFORM is not set" & exit 1 ; fi

PYNGROK_VERSION="${VERSION%.*}"
MINOR_VERSION="${PYNGROK_VERSION%.*}"
MAJOR_VERSION="${MINOR_VERSION%.*}"
DEFAULT_TAG="$DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-$VERSION$DEFAULT_TAG_SUFFIX"

###################################################################
# Determine if we should publish the built image to Docker Hub
###################################################################

PUBLISH_ARGS=""
if [[ "$PUBLISH" == "true" ]]; then
  if [[ "$DOCKER_ACCESS_TOKEN" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set, required when PUBLISH=true" & exit 1 ; fi

  echo "$DOCKER_ACCESS_TOKEN" | docker login --username "$DOCKER_USERNAME" --password-stdin

  PUBLISH_ARGS+=" --push"

  echo "--> PUBLISH=true, so the built image for $DEFAULT_TAG and tags will be published to Docker Hub with version $VERSION."
fi

###################################################################
# Build tag aliases
###################################################################

ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-$MAJOR_VERSION"
ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-$MINOR_VERSION"
ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-$PYNGROK_VERSION"
ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO-latest"
ADDITIONAL_TAG_ARGS=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$DISTRO"
if [[ "$PYTHON_VERSION" == "3.13" ]]; then
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-$VERSION"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-$MAJOR_VERSION"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-$MINOR_VERSION"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-$PYNGROK_VERSION"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO-latest"
  ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$DISTRO"

  if [[ "$DISTRO" == "slim-bookworm" ]]; then
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$MAJOR_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$MINOR_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$PYNGROK_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-$VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION-latest"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:py$PYTHON_VERSION"

    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$MAJOR_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$MINOR_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$PYNGROK_VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:$VERSION"
    ADDITIONAL_TAG_ARGS+=" -t $DOCKER_USERNAME/pyngrok:latest"
  fi
fi

###################################################################
# Build the image (and publish, if requested)
###################################################################

echo "--> Build will start for PYTHON_VERSION=$PYTHON_VERSION, DISTRO=$DISTRO, PLATFORM=$PLATFORM, VERSION=$VERSION."
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

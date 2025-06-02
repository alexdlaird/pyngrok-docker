#!/usr/bin/env bash

LINUX_PLATFORMS="linux/386,linux/amd64,linux/arm,linux/arm64,linux/ppc64le,linux/s390x"
WINDOWS_PLATFORMS="windows/amd64"

# Python 3.12 - Alpine
docker buildx build --target alpine_3_12 -t alexdlaird/pyngrok:python-3.12-alpine --platform=$LINUX_PLATFORMS 7/3.12/alpine

# Python 3.12 - Windows
#docker buildx build --target windows_3_12 -t alexdlaird/pyngrok:python-3.12-windows --platform=$WINDOWS_PLATFORMS 7/3.12/windows

.PHONY: all validate-release build clean test-downstream

SHELL := /usr/bin/env bash
PYTHON_VERSION ?= 3.13
DISTRO ?= slim-bookworm
PLATFORM ?= linux/arm64
VERSION ?= $(shell ./scripts/pypi-latest.sh)

all: build

build:
	PYTHON_VERSION=$(PYTHON_VERSION) DISTRO=$(DISTRO) PLATFORM=$(PLATFORM) ./scripts/build.sh

clean:
	rm -rf pyngrok-example-flask

test-downstream:
	@( \
		git clone https://github.com/alexdlaird/pyngrok-example-flask.git; \
		grep -qxF "NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}" pyngrok-example-flask/.env || echo "NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}" >> pyngrok-example-flask/.env; \
		( DEFAULT_TAG_SUFFIX=-custom-local make build ) || exit $$?; \
		TAG=py${PYTHON_VERSION}-${DISTRO}-${VERSION}-custom-local make -C pyngrok-example-flask test-docker; \
	)
.PHONY: all validate-release build clean test-downstream

SHELL := /usr/bin/env bash
PYTHON_VERSION ?= 3.13
DISTRO ?= slim-bookworm
PLATFORM ?= linux/arm64
VERSION ?= $(shell ./scripts/pypi-latest.sh)

all: build

validate-release:
	@if [[ "${VERSION}" == "" ]]; then echo "VERSION is not set" & exit 1 ; fi
	@if [[ "${AGENT_VERSION}" == "" ]]; then echo "AGENT_VERSION is not set" & exit 1 ; fi
	@if [[ $$(awk -v v="${VERSION}" -v a="${AGENT_VERSION}" '$$0 ~ "\\| " v " " && $$0 ~ a' README.md) == "" ]] ; then echo "README.md missing version map row for ${VERSION} -> ${AGENT_VERSION}" & exit 1 ; fi

build:
	PYTHON_VERSION=$(PYTHON_VERSION) DISTRO=$(DISTRO) PLATFORM=$(PLATFORM) ./scripts/build.sh

clean:
	rm -rf pyngrok-example-flask

test-downstream:
	( \
		git clone https://github.com/alexdlaird/pyngrok-example-flask.git; \
		grep -qxF "NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}" pyngrok-example-flask/.env || echo "NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}" >> pyngrok-example-flask/.env; \
		( DEFAULT_TAG_SUFFIX=-custom-local make build ) || exit $$?; \
		TAG=py${PYTHON_VERSION}-${DISTRO}-${VERSION}-custom-local make -C pyngrok-example-flask test-docker; \
	)
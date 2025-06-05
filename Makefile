.PHONY: all validate-release build

SHELL := /usr/bin/env bash
PYNGROK_VERSION ?= 7.2.9
PYTHON_VERSION ?= 3.13
PLATFORM ?= linux/arm64

all: build

validate-release:
	@if [[ "${VERSION}" == "" ]]; then echo "VERSION is not set" & exit 1 ; fi

	@if [[ $$(grep "PYNGROK_VERSION ?= ${VERSION}" Makefile) == "" ]] ; then echo "Version not bumped in Makefile" & exit 1 ; fi
	@if [[ $$(grep "ARG PYNGROK_VERSION=${VERSION}" Dockerfile) == "" ]] ; then echo "Version not bumped in Dockerfile" & exit 1 ; fi

build:
	PYNGROK_VERSION=$(PYNGROK_VERSION) PYTHON_VERSION=$(PYTHON_VERSION) DISTRO=slim-bookworm PLATFORM=$(PLATFORM) ./build.sh

.PHONY: all build

SHELL := /usr/bin/env bash
PLATFORM ?= linux/arm64

all: build

build:
	VERSION=latest PYTHON_VERSION=3.13 DISTRO=slim-bookworm PLATFORM=$(PLATFORM) ./build.sh

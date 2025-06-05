.PHONY: all validate-release build

SHELL := /usr/bin/env bash
PYTHON_VERSION ?= 3.13
DISTRO ?= slim-bookworm
PLATFORM ?= linux/arm64

all: build

build:
	PYTHON_VERSION=$(PYTHON_VERSION) DISTRO=$(DISTRO) PLATFORM=$(PLATFORM) ./build.sh;

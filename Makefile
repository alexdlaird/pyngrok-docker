.PHONY: all build

SHELL := /usr/bin/env bash

all: build

build:
	./build.sh

publish:
	./publish.sh

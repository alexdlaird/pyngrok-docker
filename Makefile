.PHONY: all validate-release build clean test-downstream

SHELL := /usr/bin/env bash
PYTHON_VERSION ?= 3.13
DISTRO ?= slim-bookworm
PLATFORM ?= linux/arm64

all: build

build:
	PYTHON_VERSION=$(PYTHON_VERSION) DISTRO=$(DISTRO) PLATFORM=$(PLATFORM) ./build.sh;

clean:
	rm -rf pyngrok-example-flask

test-downstream:
	@( \
		git clone https://github.com/alexdlaird/pyngrok-example-flask.git; \
		( make -C pyngrok-example-flask install ) || exit $$?; \
		source pyngrok-example-flask/venv/bin/activate; \
		( make build ) || exit $$?; \
		( make -C pyngrok-example-flask build-docker run-docker ) || exit $$?; \
		( make -C pyngrok-example-flask test ); \
	)
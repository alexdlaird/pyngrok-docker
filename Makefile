.PHONY: all build

SHELL := /usr/bin/env bash
DOCKER_USERNAME ?= alexdlaird

all: build

build:
	./build.sh

publish:
	@if [[ "${DOCKER_ACCESS_TOKEN}" == "" ]]; then echo "DOCKER_ACCESS_TOKEN is not set" & exit 1 ; fi

	@echo ${DOCKER_ACCESS_TOKEN} | docker login --username ${DOCKER_USERNAME} --password-stdin
	docker push alexdlaird/pyngrok:python-3.12-alpine
	#docker push alexdlaird/pyngrok:python-3.12-windows

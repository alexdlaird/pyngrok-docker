ARG PYTHON_VERSION=3.13
ARG DISTRO=slim-bookworm

FROM python:$PYTHON_VERSION-$DISTRO

RUN PIP_ROOT_USER_ACTION=ignore python -m pip --no-cache-dir install pyngrok
RUN ngrok

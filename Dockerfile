ARG PYTHON_VERSION=3.13
ARG DISTRO=bookworm

FROM python:$PYTHON_VERSION-$DISTRO

RUN python -m pip --no-cache-dir install pyngrok
RUN ngrok

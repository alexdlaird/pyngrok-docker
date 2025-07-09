ARG PYTHON_VERSION=3.13
ARG DISTRO=slim-bookworm

FROM python:$PYTHON_VERSION-$DISTRO

ARG PYNGROK_VERSION

RUN mkdir -p /root/.config/ngrok
RUN echo -e "version: 2\nweb_addr: 0.0.0.0:4040" >> /root/.config/ngrok/ngrok.yml

RUN PIP_ROOT_USER_ACTION=ignore python -m pip --no-cache-dir install pyngrok==$PYNGROK_VERSION

# Invoking ngrok here causes pyngrok to provision the binary in the container
RUN ngrok version

ARG PYTHON_VERSION=3.13
ARG DISTRO=slim-bookworm

FROM python:$PYTHON_VERSION-$DISTRO

RUN mkdir -p /root/.config/ngrok
RUN echo "version: 2\nweb_addr: 0.0.0.0:4040" >> /root/.config/ngrok/ngrok.yml

RUN PIP_ROOT_USER_ACTION=ignore python -m pip --no-cache-dir install pyngrok
RUN ngrok

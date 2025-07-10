ARG PYTHON_VERSION=3.13
ARG DISTRO=slim-bookworm

FROM python:$PYTHON_VERSION-$DISTRO

ARG PYNGROK_VERSION

RUN mkdir -p /root/.config/ngrok
RUN cat <<EOF > /root/.config/ngrok/ngrok.yml
version: 2
web_addr: 0.0.0.0:4040
EOF

RUN PIP_ROOT_USER_ACTION=ignore python -m pip --no-cache-dir install pyngrok==$PYNGROK_VERSION

# Invoking ngrok here causes pyngrok to provision the binary in the container
RUN ngrok version
RUN ngrok config check

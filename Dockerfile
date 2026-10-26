ARG PYTHON_VERSION=3.13
ARG DISTRO=slim-bookworm

FROM python:$PYTHON_VERSION-$DISTRO

ARG PYNGROK_VERSION
ARG VERSION

RUN mkdir -p /root/.config/ngrok
RUN cat <<EOF > /root/.config/ngrok/ngrok.yml
version: 3
agent:
  web_addr: 0.0.0.0:4040
EOF

RUN PIP_ROOT_USER_ACTION=ignore python -m pip --no-cache-dir install pyngrok==$PYNGROK_VERSION

# Invoking ngrok here causes pyngrok to provision the binary in the container
RUN ngrok version
RUN ngrok config check

LABEL org.opencontainers.image.title="pyngrok" \
      org.opencontainers.image.description="The complete ngrok agent for Python: programmatic tunnels for ingress, inspection, webhooks, demos, and APIs" \
      org.opencontainers.image.url="https://hub.docker.com/r/alexdlaird/pyngrok" \
      org.opencontainers.image.source="https://github.com/alexdlaird/pyngrok-docker" \
      org.opencontainers.image.documentation="https://pyngrok.readthedocs.io/en/latest/integrations.html#docker" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="$VERSION"

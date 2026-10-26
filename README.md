<p align="center"><img alt="pyngrok - The complete ngrok agent for Python: programmatic tunnels for ingress, inspection, webhooks, demos, and APIs" src="https://pyngrok.readthedocs.io/en/latest/_images/logo.png" /></p>

[![Version](https://img.shields.io/pypi/v/pyngrok)](https://pypi.org/project/pyngrok) [![Build](https://img.shields.io/github/actions/workflow/status/alexdlaird/pyngrok-docker/build.yml)](https://github.com/alexdlaird/pyngrok-docker/actions/workflows/build.yml) [![Docs](https://img.shields.io/readthedocs/pyngrok)](https://pyngrok.readthedocs.io/en/latest/integrations.html#docker) [![GitHub License](https://img.shields.io/github/license/alexdlaird/pyngrok-docker)](https://github.com/alexdlaird/pyngrok-docker/blob/main/LICENSE)

[`pyngrok`](https://github.com/alexdlaird/pyngrok) gives Python the complete `ngrok` agent, with programmatic tunnels
for ingress, inspection, webhooks, demos, and APIs. [`ngrok`](https://ngrok.com) is a reverse proxy that opens secure
tunnels from public URLs to localhost, and because `pyngrok` runs the real agent, you get everything it offers, from
traffic policies and OAuth to its web inspector, request replay, and `ngrok.yml` config, all callable from Python. It
downloads and manages the agent for you and tracks new `ngrok` releases, and this repo provides it in pre-built
container images on [Docker Hub](https://hub.docker.com/r/alexdlaird/pyngrok).

## Basic Usage

To launch the container into a Python shell, run:

```sh
docker run -e NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN -it alexdlaird/pyngrok
```

If you want to start in a `bash` shell instead of Python, you can launch the container with:

```sh
docker run -e NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN -it alexdlaird/pyngrok /bin/bash
```

The [`pyngrok-example-flask` repository](https://github.com/alexdlaird/pyngrok-example-flask) also includes a
`Dockerfile` and `make` commands to run it, if you would like to see a complete example.

### Config File

`ngrok` will look for its config file in this container at `/root/.config/ngrok/ngrok.yml`. If you want to provide a
custom config file, specify a mount to this file when launching the container.

```sh
docker run -v ./ngrok.yml:/root/.config/ngrok/ngrok.yml -it alexdlaird/pyngrok
```

### Web Inspector

If you want to use `ngrok`'s web inspector, be sure to expose its port. Ensure whatever config file you use
[sets `web_addr: 0.0.0.0:4040`](https://ngrok.com/docs/agent/config/v3/#web_addr) (the config provisioned in the
pre-built images already does this).

```sh
docker run --env-file .env -p 127.0.0.1:4040:4040 -it alexdlaird/pyngrok
```

### Docker Compose

Here is an example of how you could instantiate the container with `docker-compose.yml`, where you also want a given
Python script to run on startup:

```yaml
services:
  ngrok:
    image: alexdlaird/pyngrok
    env_file: ".env"
    command: [ "python", "/root/my-script.py" ]
    volumes:
      - ./my-script.py:/root/my-script.py
    ports:
      - "127.0.0.1:4040:4040"
```

Then launch it with:

```shell
docker compose up -d
```

## Documentation

For more advanced usage of `pyngrok`, its official documentation is available
on [Read the Docs](https://pyngrok.readthedocs.io).

### Command Line Usage

The `pyngrok` package puts the default `ngrok` binary on your path in the container, so all features of `ngrok` are
also available on the command line.

```sh
docker run -e NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN -it alexdlaird/pyngrok ngrok http 80
```

For details on how to fully leverage `ngrok` from the command line,
see [`ngrok`'s official documentation](https://ngrok.com/docs/agent/cli/).

## Tags & Version Map

Images are multi-architectural, and tagged with the following format:

```sh
alexdlaird/pyngrok:py$PYTHON_VERSION-$DISTRO-$VERSION
```

The following [tag variants](https://hub.docker.com/r/alexdlaird/pyngrok/tags) are available:

- `$PYTHON_VERSION` has `3.10` through `3.13`
    - If none given, defaults to `latest`
- `$DISTRO` has `alpine`, or Debian flavors of `bookworm`, `slim-bookworm`
    - If none given, defaults to `slim-bookworm`
- `$VERSION` matches the container version in table below
    - If none given, defaults to `latest`

The first three numbers of the container version correspond to the version of `pyngrok` it has installed, and you can
just use the `pyngrok` version to grab the latest tagged image for that release.

This table shows the `ngrok` version that is published in each image:

| Container Version | [Agent Version](https://ngrok.com/docs/agent/changelog/) |
|-------------------|----------------------------------------------------------|
| 9.0.3.1           | 3.39.13                                                  |
| 9.0.3.0           | 3.39.13                                                  |
| 9.0.2.0           | 3.39.11                                                  |
| 9.0.1.0           | 3.39.11                                                  |
| 9.0.0.0           | 3.39.11                                                  |
| 8.2.0.0           | 3.39.11                                                  |
| 8.1.2.0           | 3.39.1                                                   |
| 8.1.1.0           | 3.39.0                                                   |
| 8.1.0.0           | 3.38.0                                                   |
| 8.0.0.0           | 3.37.6                                                   |
| 7.5.1.0           | 3.37.1                                                   |
| 7.5.0.1           | 3.36.1                                                   |
| 7.5.0.0           | 3.33.0                                                   |
| 7.4.0.0           | 3.29.0                                                   |
| 7.3.0.1           | 3.26.0                                                   |
| 7.3.0.0           | 3.25.1                                                   |
| 7.2.12.2          | 3.25.0                                                   |
| 7.2.12.1          | 3.24.0                                                   |
| 7.2.12.0          | 3.23.3                                                   |

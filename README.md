<p align="center"><img alt="pyngrok - a Python wrapper for ngrok" src="https://pyngrok.readthedocs.io/en/latest/_images/logo.png" /></p>

[![Version](https://img.shields.io/pypi/v/pyngrok)](https://pypi.org/project/pyngrok)
[![Python Versions](https://img.shields.io/pypi/pyversions/pyngrok.svg)](https://pypi.org/project/pyngrok)
[![Build](https://img.shields.io/github/actions/workflow/status/alexdlaird/pyngrok-docker/build.yml)](https://github.com/alexdlaird/pyngrok-docker/actions/workflows/build.yml)
[![Docs](https://img.shields.io/readthedocs/pyngrok)](https://pyngrok.readthedocs.io/en/latest/integrations.html#docker)
[![GitHub License](https://img.shields.io/github/license/alexdlaird/pyngrok-docker)](https://github.com/alexdlaird/pyngrok-docker/blob/main/LICENSE)

[`pyngrok`](https://github.com/alexdlaird/pyngrok) is a Python wrapper for `ngrok` that manages its own binary,
making `ngrok` available via a convenient Python API, the command line, and (from this repo) via pre-built
container images, available on [Docker Hub](https://hub.docker.com/r/alexdlaird/pyngrok).

[`ngrok`](https://ngrok.com) is a reverse proxy that opens secure tunnels from public URLs to localhost. It's perfect
for rapid development (test webhooks, demo local websites, enable SSH access), establishing ingress to external
networks and devices, building production APIs (traffic policies, OAuth, load balancing), and more. And
it's made even more powerful with native Python integration through the `pyngrok` client.

## Basic Usage

To launch the container in to a Python shell, run:

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
[sets `web_addr: 0.0.0.0:4040`](https://ngrok.com/docs/agent/config/v2/#web_addr) (the config provisioned in the
pre-built images already does this).

```sh
docker run --env-file .env -p 4040:4040 -it alexdlaird/pyngrok
```

### Docker Compose

Here is an example of how you could instantiate the container with `docker-compose.yml`, where you also want a given
Python script to run on startup:

```yaml
services:
  ngrok:
    image: alexdlaird/pyngrok
    env_file: ".env"
    command:
      - "python /root/my-script.py"
    volumes:
      - ./my-script.py:/root/my-script.py
    ports:
      - 4040:4040
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

- `$PYTHON_VERSION` has `3.9` through `3.13`
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
| 7.3.0.1           | 3.26.0                                                   |
| 7.3.0.0           | 3.25.1                                                   |
| 7.2.12.2          | 3.25.0                                                   |
| 7.2.12.1          | 3.24.0                                                   |
| 7.2.12.0          | 3.23.3                                                   |

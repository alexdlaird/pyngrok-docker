<p align="center"><img alt="pyngrok - a Python wrapper for ngrok" src="https://pyngrok.readthedocs.io/en/latest/_images/logo.png" /></p>

[![Python Versions](https://img.shields.io/pypi/pyversions/pyngrok.svg)](https://pypi.org/project/pyngrok)
[![Build](https://img.shields.io/github/actions/workflow/status/alexdlaird/pyngrok-docker/build.yml)](https://github.com/alexdlaird/pyngrok-docker/actions/workflows/build.yml)
[![Docs](https://img.shields.io/readthedocs/pyngrok)](https://pyngrok.readthedocs.io/en/latest)
[![GitHub License](https://img.shields.io/github/license/alexdlaird/pyngrok)](https://github.com/alexdlaird/pyngrok/blob/main/LICENSE)

[`pyngrok`](https://github.com/alexdlaird/pyngrok) is a Python wrapper for `ngrok` that manages its own binary,
making `ngrok` available via a convenient Python API, the command line, and (from this repo) via pre-built Docker
images (based off the official Python images), available on [Docker Hub](https://hub.docker.com/r/alexdlaird/pyngrok).

[`ngrok`](https://ngrok.com) is a reverse proxy that opens secure tunnels from public URLs to localhost. It's perfect
for rapid  development (test webhooks, demo local websites, enable SSH access), establishing ingress to external
networks and devices, building production APIs (traffic policies, OAuth, load balancing), and more. And
it's made even more powerful with native Python integration through the `pyngrok` client.

## Basic Usage

To launch the container in to a Python shell with `pyngrok` installed, run:

```sh
docker run -e NGROK_AUTHTOKEN=<NGROK_AUTHTOKEN> -it alexdlaird/pyngrok
```

Instead of launching directly in to Python, you can also start in a `bash` shell, allowing more direct interactions
with the container.

```sh
docker run -e NGROK_AUTHTOKEN=<NGROK_AUTHTOKEN> -it alexdlaird/pyngrok /bin/bash
```
### Config File

By default, `ngrok` will look for a config file at `/root/.config/ngrok/ngrok.yml`. If you want to mount a custom
config file, specify a mount to this file when launching the container.

```sh
docker run -v ./ngrok.yml:/root/.config/ngrok/ngrok.yml -it alexdlaird/pyngrok
```

### Web Inspector

If you want to use `ngrok`'s web inspector, be sure to expose its port (defaults to 4040). If you're not using the
default config file provided in the container, be sure to [set `web_addr: 0.0.0.0:4040`](https://ngrok.com/docs/agent/config/v2/#web_addr).

```sh
docker run --env-file .env -p 4040:4040 -it alexdlaird/pyngrok
```

### Docker Compose

Here is an example of how you could launch the container using `docker-compose.yml`. In this example, there is also
a Python script that will be run on startup:

```yaml
services:
  ngrok:
    image: alexdlaird/pyngrok
    env_file: ".env"
    command:
      - "python /root/my-script.py"
    volumes:
      - ./ngrok.yml:/root/.config/ngrok/ngrok.yml
      - ./my-script.py:/root/my-script.py
    ports:
      - 4040:4040
```

To launch the container with Docker Compose, execute:

```shell
docker compose up -d
```

## Documentation

For more advanced usage of `pyngrok`, its official documentation is available
on [Read the Docs](https://pyngrok.readthedocs.io).

### Command Line Usage

`pyngrok` package puts the default `ngrok` binary on your path in the container. So all features of `ngrok` are
also available on the command line.

```sh
docker run -e NGROK_AUTHTOKEN=<NGROK_AUTHTOKEN> -it alexdlaird/pyngrok ngrok http 80
```

For details on how to fully leverage `ngrok` from the command line,
see [`ngrok`'s official documentation](https://ngrok.com/docs/agent/cli/).

## Tags & Version Map

Images are multi-architectural, and tagged with the following format:

```sh
alexdlaird/pyngrok:py<PYTHON_VERSION>-<DISTRO>-<VERSION>
```

They are available with the following tag variants:

- `<PYTHON_VERSION>` has `3.8` through `3.13`
  - If none given, defaults to `3.13`
- `<DISTRO>` has `alpine`, or Debian flavors of `bookworm`, `slim-bookworm`, `bullseye`, `slim-bullseye`
  - If none given, defaults to `slim-bookworm`
- `<VERSION>` match the table below
  - If none given, defaults to `-latest`

For reference, [`<VERSION>` releases](https://github.com/alexdlaird/pyngrok-docker/releases) map to the following `pyngrok` and `ngrok` versions:

| Container Version | `pyngrok` Version | `ngrok` Version |
|-------------------|-------------------|-----------------|
| 1.0               | 7.2               | 3.22            |

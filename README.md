# pyngrok-docker

This repo is still a WIP, just learning the process of publishing base Docker images. The current images
being published will be deleted in the future, and replaced with a matrix of distros and Python versions
alongside a stable build.

Example to use one of the WIP containers:

```sh
docker run --env-file .env -it alexdlaird/pyngrok:3.13-bookworm
```

Version Map

| Container Version | `pyngrok` Version | `ngrok` Version |
|-------------------|-------------------|-----------------|
| 1.0               | 7.2.9             | 3.22.1          |

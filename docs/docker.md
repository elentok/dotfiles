# Docker

## Install on Raspberry PI

Fetch and run the installer script:

```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Add non-root user to the docker group (so that user can execute docker commands):

```
sudo usermod -aG docker $(whoami)
```

## Podman

[Podman][1] is a daemonless, Linux native tool (can be installed with `apt install podman`).

### Add aliases to docker shortnames

For example, for podman to support `podman pull node:14-alpine` edit
`/etc/containers/registries.conf.d/shortnames.conf` and add:

```
"node" = "docker.io/library/node"
```

[1]: https://docs.podman.io/en/latest/

## Run a private container registry

### Setup the registry server

```sh
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

The `--restart=always` parameter makes sure it restarts automatically when Docker restarts or if it
exists.

### Setup docker for accessing private insecure container registry

To access a non-https registry (like the one we created above) create `/etc/docker/daemon.json` with
the following content:

```
{
  "insecure-registries": ["{host}:5000"]
}
```

Where `{host}` should be replaced with the hostname (e.g. `mypi.localdomain`).

On Windows open Docker Desktop, go to "Settings" and "Docker Engine", there you can see a text field
where you need to add the "insecure-registries" key and then restart docker.

### Setup podman for accessing private insecure container registry

To access a non-https registry (like the one we created above) create
`/etc/containers/registries.conf.d/private-insecure.conf` with the following content:

```
[[registry]]

prefix = "{host}:5000"
location = "{host}:5000"
insecure = true
```

Where `{host}` should be replaced with the hostname (e.g. `mypi.localdomain`).

## Enable multi-arch building

WIP

1. Setup qemu-user-static

Run:

```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

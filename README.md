# ROCm Docker Container

Host Radeon Open Compute Platform runtime inside a Docker container.

The host Linux system must provide a compatible ROCm driver and a supported GPU.

The following setup has been tested:

* GPU: `Radeon RX Vega gfx900` 
* Host: `rocm-dev 4.5.0.40500-56`
* Container: `rocm-dev 5.0.1.50001-59`

Upon the startup, the container replicates the current system user as a container user with exactly same groups and ids. This is one reliable way to allow GPU usage from within the container on behalf of non-priviledged user.

## Building

```
docker build -t rocm/rocm-docker .
```

## Running

The following commands assume that the current host system user is permitted to use the GPU.

* Run interactively from the command line:

```
docker run --rm -it --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined --env ID="$(id)" rocm/rocm-docker
```

* Run a background service with `docker-compose`, and connect to it when needed:

```
./compose.sh
docker-compose exec rocm-docker sudo -i -u $(whoami)
```


# ROCm Docker Container

Host Radeon Open Compute Platform runtime inside a Docker container.

The host Linux system must provide a compatible ROCm driver and a supported GPU.

The following setup has been tested:

* GPU: `Radeon RX Vega gfx900` 
* Host: `rocm-dev 4.5.0.40500-56`
* Container: `rocm-dev 5.0.1.50001-59`

Upon the startup, the container replicates the current system user as a container user with exactly same groups and ids. This is one reliable way to allow GPUusage from within the container on behalf of non-priviledged user.

## Building

```
docker build -t rocm/rocm-docker .
```

## Running

* Command line:

```
docker run --rm -it --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined --env ID="$(id)" rocm/rocm-docker
```

* Docker container:

```
./compose.sh
docker-compose exec rocm-docker sudo -i -u $(whoami)
```


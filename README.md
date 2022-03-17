# ROCm Docker Container

Host Radeon Open Compute Platform runtime in a Docker container.

The host Linux system must provide a compatible ROCm driver and a supported GPU.

The following setup has been tested:

* GPU: `Radeon RX Vega gfx900` 
* Host: `rocm-dev 4.5.0.40500-56`
* Container: `rocm-dev 5.0.1.50001-59`

## Building

```
docker build -t rocm/rocm-terminal .
```

## Running

* Command line:

```
docker run --rm -it --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined --env ID="$(id)" rocm/rocm-terminal
```

* Docker container:

```
docker-compose up -d
```


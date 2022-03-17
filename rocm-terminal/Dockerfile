# docker build -t rocm/rocm-terminal rocm-terminal
# dmikushin@Feba-Ubuntu-20:~/forge/ROCm-docker$ docker run --rm -it --device=/dev/kfd --device=/dev/dri --security-opt seccomp=unconfined --env ID="$(id)" rocm/rocm-terminal

FROM ubuntu:20.04
MAINTAINER Dmitry Mikushin <dmitry@kernelgen.org>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends perl lsb-release

COPY ./get_latest_version.pl / 

RUN apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
  curl -sL http://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - && \
  ROCM_REPO=$(perl /get_latest_version.pl http://repo.radeon.com/rocm/apt/#) \
  sh -c 'echo deb [arch=amd64] $ROCM_REPO ubuntu main > /etc/apt/sources.list.d/rocm.list' && \
  AMDGPU_REPO=$(perl /get_latest_version.pl https://repo.radeon.com/amdgpu/#/ubuntu) \
  sh -c 'echo deb [arch=amd64] $AMDGPU_REPO $(lsb_release -cs) main > /etc/apt/sources.list.d/amdgpu.list' && \
  apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  libelf1 \
  libnuma-dev \
  build-essential \
  git \
  vim-nox \
  cmake-curses-gui \
  kmod \
  file \
  python3 \
  python3-pip \
  rocm-dev \
  clinfo && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Grant members of 'sudo' group passwordless privileges
# Comment out to require sudo
COPY sudo-nopasswd /etc/sudoers.d/sudo-nopasswd

ENV PATH "${PATH}:/opt/rocm/bin"

# The following are optional enhancements for the command-line experience
# Uncomment the following to install a pre-configured vim environment based on http://vim.spf13.com/
# 1.  Sets up an enhanced command line dev environment within VIM
# 2.  Aliases GDB to enable TUI mode by default
#RUN curl -sL https://j.mp/spf13-vim3 | bash && \
#    echo "alias gdb='gdb --tui'\n" >> ~/.bashrc

ENV ID "${ID}"

# entrypoint is used to create a user with uid/gid and groups matching the host system
COPY entrypoint.pl /entrypoint.pl
RUN chmod +x /entrypoint.pl
ENTRYPOINT ["/entrypoint.pl"]

# Default to a login shell
CMD ["bash", "-l"]


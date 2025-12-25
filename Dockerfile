# Ubuntu 24.04 LTS release instead of latest to ensure a stable environment
FROM ubuntu:24.04 AS base-all

# Use the specified target architecture, or the host architecture if not set
ARG TARGETARCH

# AMD64 build parameters
FROM base-all AS build-amd64
ARG BUILD_ARCH="x86_64"

# ARM64 build parameters
FROM base-all AS build-arm64
ARG BUILD_ARCH="aarch64"

FROM build-${TARGETARCH} AS final

# Remove ubuntu user to free uid=1000 and gid=1000
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

# Create a default Wirepas user
ARG user=wirepas
RUN useradd -ms /bin/bash ${user}

# Install packages for software development: python3, git, doxygen, ...
RUN apt-get update \
    && apt-get install -y \
       curl \
       doxygen \
       git \
       python3 \
       python3-pip \
       xz-utils \
    && rm -fr /var/libapt/lists/*

# Install Python packages
#
# The pycryptodome package is needed for scratchpad image generation.
#
# NOTE: The Ubuntu python3-pycryptodome system package is based on the
# pycryptodomex Python package, which uses the "Cryptodome" Python namespace.
# Wirepas SDK utilities use the "Crypto" Python namespace, so the Ubuntu package
# cannot be used.
RUN pip3 install --break-system-packages pycryptodome==3.20.0

# Tool to generate clang's "compile_command.json" for make-based projects
RUN pip3 install compiledb==0.10.1

WORKDIR /home/${user}

# Download and install the correct ARM toolchain based on target architecture
ARG ARM_TOOLCHAIN_NAME_NO_ARCH="arm-gnu-toolchain-12.2.rel1-arm-none-eabi"
ARG ARM_TOOLCHAIN_NAME="arm-gnu-toolchain-12.2.rel1-${BUILD_ARCH}-arm-none-eabi"
ARG ARM_TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/${ARM_TOOLCHAIN_NAME}.tar.xz"

RUN curl -Lso arm-gnu-toolchain.tar.xz "${ARM_TOOLCHAIN_URL}" \
    && tar -xf arm-gnu-toolchain.tar.xz -C /opt/ \
    && rm -f arm-gnu-toolchain.tar.xz \
    && ln -s "${ARM_TOOLCHAIN_NAME}" "/opt/${ARM_TOOLCHAIN_NAME_NO_ARCH}"

# Add ARM toolchain to default path
ENV PATH="/opt/${ARM_TOOLCHAIN_NAME_NO_ARCH}/bin:${PATH}"

# No need to be root anymore
USER ${user}

# Default to bash console
CMD ["/bin/bash"]

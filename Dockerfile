FROM ubuntu:20.04
# Use the 20.04 LTS release instead of latest to have stable environement

# Create a default Wirepas user
ARG user=wirepas
ARG group=wirepas
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Wirepas user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}

# Install python3, pip and wget
RUN apt-get update \
    && apt-get install -y python3 python3-pip \
    && apt-get install -y curl \
    && rm -fr /var/libapt/lists/*

# Install pycryptodome package needed for scratchpad image generation
RUN pip3 install pycryptodome

WORKDIR /home/${user}

# Install Arm compiler
RUN curl -Lso gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" \
    && tar xjf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 -C /opt/ \
    && rm gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2

# Add Gcc 7 compiler to default path
ENV PATH="/opt/gcc-arm-none-eabi-7-2017-q4-major/bin:${PATH}"

# No need to be root anymore
USER ${user}

# Default to bash console
CMD ["/bin/bash"]

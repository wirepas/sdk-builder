FROM ubuntu:20.04
# Use the 20.04 LTS release instead of latest to have stable environement

# Create a default Wirepas user
ARG user=wirepas
RUN useradd -ms /bin/bash ${user}

# Install python3, pip and wget
RUN apt-get update \
    && apt-get install -y \
       curl \
       doxygen \
       python3 \
       python3-pip \
    && rm -fr /var/libapt/lists/*

# Install pycryptodome package needed for scratchpad image generation
RUN pip3 install pycryptodome==3.9.7

WORKDIR /home/${user}

# Install Arm compiler
RUN curl -Lso gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" \
    && tar xjf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 -C /opt/ \
    && rm -f gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2

# Add Gcc 7 compiler to default path
ENV PATH="/opt/gcc-arm-none-eabi-7-2017-q4-major/bin:${PATH}"

# No need to be root anymore
USER ${user}

# Default to bash console
CMD ["/bin/bash"]

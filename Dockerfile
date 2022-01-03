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
       git \
       python3 \
       python3-pip \
    && rm -fr /var/libapt/lists/*

# Install pycryptodome package needed for scratchpad image generation
RUN pip3 install pycryptodome==3.9.7

WORKDIR /home/${user}

# Install Arm compiler
RUN curl -Lso gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2?revision=ca0cbf9c-9de2-491c-ac48-898b5bbc0443&hash=3710A129B3F3955AFDC7A74934A611E6C7F218AE" \
    && tar xjf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -C /opt/ \
    && rm -f gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2

# Add Gcc 10 compiler to default path
ENV PATH="/opt/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux/bin:${PATH}"

# No need to be root anymore
USER ${user}

# Default to bash console
CMD ["/bin/bash"]

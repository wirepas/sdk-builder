FROM ubuntu:24.04
# Use the 24.04 LTS release instead of latest to have stable environement

# Remove ubuntu user to free uid=1000 and gid=1000
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

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

# Install pycryptodome package (Crypto module)
# needed for scratchpad image generation.
# Note! Ubuntu python3-pycryptodome system package
# is based on pycryptodomex (Cryptodome module),
# not to pycryptodome (Crypto module), thus
# it cannot be used instead.
RUN pip3 install --break-system-packages pycryptodome==3.20.0

WORKDIR /home/${user}

# Install Arm compiler
RUN curl -Lso gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2" \
    && tar xjf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /opt/ \
    && rm -f gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

# Add Gcc 10.3 compiler to default path
ENV PATH="/opt/gcc-arm-none-eabi-10.3-2021.10/bin:${PATH}"

# No need to be root anymore
USER ${user}

# Default to bash console
CMD ["/bin/bash"]

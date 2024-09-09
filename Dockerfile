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
RUN curl -Lso arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz?rev=7bd049b7a3034e64885fa1a71c12f91d&hash=732D909FA8F68C0E1D0D17D08E057619" \
    && tar -xf arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz -C /opt/ \
    && rm -f arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz

# Add Gcc 12.2.rel1 compiler to default path
ENV PATH="/opt/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi/bin:${PATH}"

# No need to be root anymore
USER ${user}

# Default to bash console
CMD ["/bin/bash"]

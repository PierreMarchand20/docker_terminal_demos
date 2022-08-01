FROM ubuntu:jammy-20220428 AS asciinema_playground

WORKDIR /root

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    ssh \
    libssl-dev \
    git \
    vim \
    python3-pip python3-dev\
    && pip3 --no-cache-dir install --upgrade pip \
    && pip3 --no-cache-dir install wheel setuptools asciinema \
    && git clone https://github.com/PierreMarchand20/asciinema_automation.git \
    && cd asciinema_automation \
    && pip3 install . \
    && rm -rf /var/lib/apt/lists/*


#### ADD DEFAULT USER ####
ARG USER=Bob
ENV USER ${USER}
ENV USER_HOME /home/${USER}
RUN useradd -s /bin/bash --user-group --system --create-home --no-log-init ${USER}

ARG USER=Alice
ENV USER ${USER}
ENV USER_HOME /home/${USER}
RUN useradd -s /bin/bash --user-group --system --create-home --no-log-init ${USER}

USER ${USER}
WORKDIR ${USER_HOME}

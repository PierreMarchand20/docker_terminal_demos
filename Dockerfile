FROM ubuntu:jammy-20220428 AS asciinema_playground_base

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
    man \
    less \
    && yes | unminimize \
    && pip3 --no-cache-dir install --upgrade pip \
    && pip3 --no-cache-dir install wheel setuptools asciinema \
    && rm -rf /var/lib/apt/lists/*

FROM asciinema_playground_base AS asciinema_playground

RUN git clone https://github.com/PierreMarchand20/asciinema_automation.git \
    && cd asciinema_automation \
    && pip3 --no-cache-dir install . 

#### ADD DEFAULT USER ####
ARG USER=Bob
ENV USER ${USER}
ENV USER_HOME /home/${USER}
RUN useradd -s /bin/bash --user-group --system --create-home --no-log-init ${USER}

ARG USER=Alice
ENV USER ${USER}
ENV USER_HOME /home/${USER}
RUN useradd -s /bin/bash --user-group --system --create-home --no-log-init ${USER} \
    && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O /home/${USER}/.git-prompt.sh \
    && echo 'source ~/.git-prompt.sh\nGIT_PS1_SHOWDIRTYSTATE=1\nGIT_PS1_SHOWCOLORHINTS="enable"\nPROMPT_COMMAND='"'"'__git_ps1 "\w" "$ "'"'"'' >> /home/${USER}/.bashrc
USER ${USER}
WORKDIR ${USER_HOME}

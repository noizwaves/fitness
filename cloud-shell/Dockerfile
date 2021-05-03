FROM debian:buster

RUN apt-get update && apt-get install -y \
        git \
        bash \
        curl \
        openssh-client \
        vim \
        procps

# buildx CLI
RUN curl -fsOL https://github.com/docker/buildx/releases/download/v0.5.1/buildx-v0.5.1.linux-amd64 && \
    chmod +x buildx-v0.5.1.linux-amd64 && \
    mv buildx-v0.5.1.linux-amd64 /usr/local/bin/buildx

# devspace CLI + loft plugin
RUN curl -fsOL https://github.com/loft-sh/devspace/releases/download/v5.12.1/devspace-linux-amd64 && \
    chmod +x devspace-linux-amd64 && \
    mv devspace-linux-amd64 /usr/local/bin/devspace && \
    devspace add plugin https://github.com/loft-sh/loft-devspace-plugin

# Visual Studio Code
RUN curl -fsSL https://code-server.dev/install.sh | sh

# gh CLI
#RUN curl -fsOL https://github.com/cli/cli/releases/download/v1.9.2/gh_1.9.2_linux_amd64.tar.gz && \
#    tar -zxf gh_1.9.2_linux_amd64.tar.gz && \
#    chown -R root:root gh_1.9.2_linux_amd64 && \
#    cp gh_1.9.2_linux_amd64/bin/* /usr/local/bin && \
#    cp -R gh_1.9.2_linux_amd64/share/* /usr/local/share &&
#    rm -rf gh_1.9.2_linux_amd64 gh_1.9.2_linux_amd64.tar.gz

# Setup aliases
ADD .bashrc /root/

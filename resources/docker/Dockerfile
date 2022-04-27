# syntax=docker/dockerfile:1

# Docker image build arguments:
ARG baseimage=centos:7
ARG checkmkversion=2.0.0p21
ARG kubectlversion=1.21.11
ARG port=6556

#######################################
## Local Stage                        #
#######################################
FROM ${baseimage} as local-stage

# Docker image build arguments:
ARG checkmkversion
ARG kubectlversion
ARG port

# Set up custom yum repos:
COPY ./resources/docker/yum.repos.d/* /etc/yum.repos.d

# Package installs/updates:
RUN yum install -y epel-release
RUN yum install -y bind-utils \
    kubectl-${kubectlversion} \
    less \
    net-tools \
    openssh-clients \
    python-jsonpointer \
    s3cmd \
    unzip \
    which
RUN yum clean all && rm -rf /var/cache/yum

# Change working directory:
WORKDIR /tmp

# Install AWS CLI
RUN curl -LO https://raw.githubusercontent.com/slateci/docker-images/stable/slate-client-server/scripts/install-aws-cli.sh
RUN chmod +x ./install-aws-cli.sh && \
    ./install-aws-cli.sh && \
    rm ./install-aws-cli.sh

# Install CheckMK Agent
RUN curl -LO https://sl-um-oob1.slateci.io/SLATE/check_mk/agents/check-mk-agent-${checkmkversion}-1.noarch.rpm
RUN yum install -y ./check-mk-agent-${checkmkversion}-1.noarch.rpm

# Make root slate directory:
RUN mkdir /slate

# Change working directory:
WORKDIR /

# Ports:
EXPOSE ${port}

# Run once the container has started:
ENTRYPOINT [ "/bin/bash" ]

#######################################
## Release Stage                      #
#######################################
FROM ${baseimage} as release-stage

# Docker image build arguments:
ARG checkmkversion
ARG kubectlversion
ARG port

# Package installs/updates:
RUN yum install epel-release -y
RUN yum install bind-utils \
    less \
    net-tools \
    openssh-clients \
    python-jsonpointer \
    s3cmd \
    unzip \
    which -y
RUN yum clean all && rm -rf /var/cache/yum

# Change working directory:
WORKDIR /usr/local/bin

# Install AWS CLI
COPY --from=local-stage /usr/local/aws-cli /usr/local/aws-cli
RUN ln -s /usr/local/aws-cli/v2/current/bin/aws aws && \
    ln -s /usr/local/aws-cli/v2/current/bin/aws_completer aws_completer

# Install CheckMK Agent
RUN curl -LO https://sl-um-oob1.slateci.io/SLATE/check_mk/agents/check-mk-agent-${checkmkversion}-1.noarch.rpm
RUN yum install -y ./check-mk-agent-${checkmkversion}-1.noarch.rpm

# Install Kubectl:
COPY --from=local-stage /usr/bin/kubectl kubectl

# Change working directory:
WORKDIR /slate

# Copy in all scripts:
COPY ./scripts ./scripts
RUN chmod +x ./scripts/*.sh

# Ports:
EXPOSE ${port}

# Change working directory:
WORKDIR /

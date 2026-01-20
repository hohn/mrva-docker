FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Build-time arguments (authoritative versions supplied by build scripts)
ARG CODEQL_VERSION
ARG GO_VERSION=1.25.5
ARG TARGETARCH

# Base packages
RUN apt-get update && apt-get install --no-install-recommends --assume-yes \
    ca-certificates \
    curl \
    unzip \
    git \
    default-jdk \
    python3 \
    python3-venv \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------
# Install Go (exact version)
# --------------------------------------------------------------------
RUN curl -L "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
      -o /tmp/go.tgz && \
    tar -C /usr/local -xzf /tmp/go.tgz && \
    rm /tmp/go.tgz

ENV PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# --------------------------------------------------------------------
# Install CodeQL (exact version, pinned)
# --------------------------------------------------------------------
RUN test -n "$CODEQL_VERSION" || (echo "CODEQL_VERSION not set" && exit 1)

RUN curl -L \
      "https://github.com/github/codeql-cli-binaries/releases/download/v${CODEQL_VERSION}/codeql-linux64.zip" \
      -o /tmp/codeql.zip && \
    unzip /tmp/codeql.zip -d /opt && \
    rm /tmp/codeql.zip && \
    chmod -R +x /opt/codeql

ENV CODEQL_CLI_PATH=/opt/codeql/codeql
ENV PATH=/opt/codeql:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ARM compatibility (harmless on amd64)
ENV CODEQL_JAVA_HOME=/usr

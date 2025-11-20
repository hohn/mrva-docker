FROM golang:1.22 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the host directory containing the git clone to the container
COPY mrvaserver.tmp /app/mrvaserver

# Set the environment variables for Go modules
ENV GO111MODULE=on
ENV CGO_ENABLED=0

# Build the project
WORKDIR /app/mrvaserver
RUN go mod tidy && go build -o /app/mrvaserver-binary

# # Download dependencies
# RUN go mod download

# Create a runtime container
FROM ubuntu:24.04 AS runner
ENV DEBIAN_FRONTEND=noninteractive

# Build argument for CodeQL version, defaulting to the latest release
ARG CODEQL_VERSION=latest

# Install packages
RUN apt-get update && apt-get install --no-install-recommends --assume-yes \
    unzip curl ca-certificates default-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# If the version is 'latest', lsget the latest release version from GitHub, unzip the bundle into /opt, and delete the archive
RUN if [ "$CODEQL_VERSION" = "latest" ]; then \
    CODEQL_VERSION=$(curl -s https://api.github.com/repos/github/codeql-cli-binaries/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/'); \
    fi && \
    echo "Using CodeQL version $CODEQL_VERSION" && \
    curl -L "https://github.com/github/codeql-cli-binaries/releases/download/$CODEQL_VERSION/codeql-linux64.zip" -o /tmp/codeql.zip && \
    unzip /tmp/codeql.zip -d /opt && \
    rm /tmp/codeql.zip && \
    chmod -R +x /opt/codeql

# Set environment variables for CodeQL
ENV CODEQL_CLI_PATH=/opt/codeql/codeql

# Set environment variable for CodeQL for `codeql database analyze` support on ARM
# This env var has no functional effect on CodeQL when running on x86_64 linux
ENV CODEQL_JAVA_HOME=/usr

# Copy the built binary from the builder stage
COPY --from=builder /app/mrvaserver-binary /usr/local/bin/mrvaserver

# Copy the binary-replacement support script to the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Run the server with the default mode set to container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--mode=container"]

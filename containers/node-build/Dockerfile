# Use a lightweight Debian-based image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR="/usr/local/nvm"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    git \
    python3 \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create NVM directory
RUN mkdir -p $NVM_DIR

# Install NVM and Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 

# # Manually set Node.js path (since `nvm` is not persistent in non-interactive shells)
# ENV NODE_PATH="$NVM_DIR/versions/node/$(ls $NVM_DIR/versions/node)/lib/node_modules"
# ENV PATH="$NVM_DIR/versions/node/$(ls $NVM_DIR/versions/node)/bin:$PATH"

# # Install VSCE (Visual Studio Code Extension CLI)
# RUN npm install -g @vscode/vsce

# # Set working directory to match extension location
# WORKDIR /workspace/extensions/ql-vscode

# # Default command: build and package the extension
# CMD ["sh", "-c", "npm install && npm run build && vsce package"]

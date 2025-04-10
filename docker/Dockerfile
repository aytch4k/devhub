FROM node:20-bookworm

# Install dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    xvfb \
    libgtk-3-0 \
    libxkbfile-dev \
    libkrb5-dev \
    libgbm1 \
    libsecret-1-dev \
    rpm \
    python3 \
    git \
    curl \
    wget \
    gpg \
    build-essential \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

# Set up environment
ENV ELECTRON_SKIP_BINARY_DOWNLOAD=1
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Create app directory
WORKDIR /app

# Copy the entire codebase
COPY . .

# Install dependencies
RUN npm ci --legacy-peer-deps

# Download builtin extensions
RUN npm run download-builtin-extensions

# Build commands
CMD ["npm", "run", "compile"]

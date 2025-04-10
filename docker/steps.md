# Building VSCode with Docker - Step by Step Guide

This document provides detailed steps to build VSCode using Docker.

## Step 1: Prerequisites

Ensure you have the following installed:
- Docker
- Docker Compose

## Step 2: Understanding the Docker Setup

The Docker configuration consists of:

1. **Dockerfile**: Contains all the dependencies and setup needed to build VSCode
2. **docker-compose.yml**: Defines services for building and running VSCode
3. **README.md**: Documentation on how to use the Docker setup

## Step 3: Building VSCode

1. Navigate to the repository root:
   ```bash
   cd /path/to/vscode/repo
   ```

2. Build the Docker image:
   ```bash
   docker-compose -f docker/docker-compose.yml build
   ```

3. Compile VSCode:
   ```bash
   docker-compose -f docker/docker-compose.yml run vscode-build
   ```

   This will:
   - Install all dependencies
   - Download builtin extensions
   - Compile the VSCode source code

## Step 4: Running VSCode

### Option 1: Run in Development Mode

1. Start VSCode in watch mode:
   ```bash
   docker-compose -f docker/docker-compose.yml run vscode-dev
   ```

2. In another terminal, run the Electron app:
   ```bash
   docker-compose -f docker/docker-compose.yml run vscode-run
   ```

### Option 2: Run the Compiled Application

```bash
docker-compose -f docker/docker-compose.yml run vscode-run
```

## Step 5: Accessing the VSCode UI

To run the VSCode UI, you need to allow Docker to access your X server:

### On Linux:
```bash
xhost +local:docker
```

### On macOS:
1. Install XQuartz
2. Run:
   ```bash
   xhost +localhost
   ```

## Step 6: Building for Different Architectures

To build for a different architecture (e.g., ARM64):

```bash
VSCODE_ARCH=arm64 npm_config_arch=arm64 docker-compose -f docker/docker-compose.yml run vscode-build
```

## Step 7: Troubleshooting

### Common Issues:

1. **X11 Display Issues**:
   - Ensure DISPLAY environment variable is set correctly
   - Make sure X server is allowing connections from Docker

2. **Build Failures**:
   - Check Docker has enough resources (memory, CPU)
   - Verify all dependencies are installed correctly

3. **Node.js Version Issues**:
   - The Dockerfile uses Node.js 20, which matches the version in .nvmrc
   - If you need a different version, update the Dockerfile

## Step 8: Customizing the Build

You can customize the build by:

1. Modifying environment variables in docker-compose.yml
2. Adding build arguments to the Dockerfile
3. Creating a .env file with your custom configurations

## Step 9: Creating Distribution Packages

To create distribution packages (deb, rpm, etc.):

1. Build VSCode first:
   ```bash
   docker-compose -f docker/docker-compose.yml run vscode-build
   ```

2. Run the packaging command:
   ```bash
   docker-compose -f docker/docker-compose.yml run vscode-build npm run gulp vscode-linux-x64-build-deb
   ```

   Replace `vscode-linux-x64-build-deb` with the appropriate gulp task for your desired package format.

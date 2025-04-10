# Building VSCode with Docker

This directory contains Docker configuration files to build and run VSCode in a containerized environment.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Files

- `Dockerfile`: Defines the container image with all necessary dependencies to build VSCode
- `docker-compose.yml`: Defines services for building, developing, and running VSCode
- `build-vscode.sh`: Helper script to simplify building and running VSCode
- `.dockerignore`: Specifies files to exclude from the Docker build context

## Services

The `docker-compose.yml` file defines three services:

1. **vscode-build**: Compiles VSCode
2. **vscode-dev**: Runs VSCode in watch mode for development
3. **vscode-run**: Runs the compiled VSCode application

## Usage

### Using the Helper Script

The easiest way to build and run VSCode is to use the provided helper script:

```bash
# Navigate to the repository root
user@ubuntu:~$ cd /path/to/vscode/repo

# Make the script executable (on Linux/macOS)
user@ubuntu:/path/to/vscode/repo$ chmod +x docker/build-vscode.sh

# Build VSCode
user@ubuntu:/path/to/vscode/repo$ ./docker/build-vscode.sh --build

# Build and run VSCode
user@ubuntu:/path/to/vscode/repo$ ./docker/build-vscode.sh --run

# Run in development mode
user@ubuntu:/path/to/vscode/repo$ ./docker/build-vscode.sh --dev

# Build for a specific architecture
user@ubuntu:/path/to/vscode/repo$ ./docker/build-vscode.sh --arch arm64

# Create a package
user@ubuntu:/path/to/vscode/repo$ ./docker/build-vscode.sh --package deb
```

### Manual Usage with Docker Compose

If you prefer to use Docker Compose directly:

```bash
# Navigate to the repository root
cd /path/to/vscode/repo

# Build VSCode
docker-compose -f docker/docker-compose.yml run vscode-build

# Run VSCode in watch mode
docker-compose -f docker/docker-compose.yml run vscode-dev

# Run the compiled VSCode application
docker-compose -f docker/docker-compose.yml run vscode-run
```

## Display Configuration

To run the VSCode UI, you need to allow Docker to access your X server:

```bash
# On Linux
user@ubuntu:/path/to/vscode/repo$ xhost +local:docker

# On macOS, you need to install XQuartz and run:
user@macos:~$ xhost +localhost
```

## Volumes

The Docker Compose configuration uses volumes to persist data:

- `vscode-node-modules`: Stores npm dependencies
- `vscode-build-output`: Stores build artifacts

This ensures that you don't have to reinstall dependencies or rebuild everything from scratch each time you run the container.

## Customization

You can customize the build by modifying environment variables in the `docker-compose.yml` file:

- `VSCODE_ARCH`: Architecture to build for (default: x64)
- `npm_config_arch`: Architecture for npm packages (default: x64)

For example, to build for ARM64:

```bash
user@ubuntu:/path/to/vscode/repo$ VSCODE_ARCH=arm64 npm_config_arch=arm64 docker-compose -f docker/docker-compose.yml run vscode-build

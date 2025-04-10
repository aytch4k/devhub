#!/bin/bash

# Script to build VSCode using Docker

set -e

# Navigate to the repository root
cd "$(dirname "$0")/.."

# Function to display help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Build VSCode using Docker"
    echo ""
    echo "Options:"
    echo "  -h, --help            Show this help message"
    echo "  -b, --build           Build VSCode (default action)"
    echo "  -r, --run             Run VSCode after building"
    echo "  -d, --dev             Run in development mode (watch)"
    echo "  -a, --arch ARCH       Set architecture (x64, arm64, armhf)"
    echo "  -c, --clean           Clean build artifacts before building"
    echo "  -p, --package TYPE    Create package (deb, rpm, snap)"
    echo ""
    echo "Examples:"
    echo "  $0 --build            Build VSCode"
    echo "  $0 --run              Build and run VSCode"
    echo "  $0 --dev              Run in development mode"
    echo "  $0 --arch arm64       Build for ARM64 architecture"
    echo "  $0 --package deb      Create a .deb package"
}

# Default values
ACTION="build"
ARCH="x64"
CLEAN=false
PACKAGE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -b|--build)
            ACTION="build"
            shift
            ;;
        -r|--run)
            ACTION="run"
            shift
            ;;
        -d|--dev)
            ACTION="dev"
            shift
            ;;
        -a|--arch)
            ARCH="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -p|--package)
            PACKAGE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate architecture
if [[ "$ARCH" != "x64" && "$ARCH" != "arm64" && "$ARCH" != "armhf" ]]; then
    echo "Error: Invalid architecture. Must be one of: x64, arm64, armhf"
    exit 1
fi

# Set environment variables
export VSCODE_ARCH="$ARCH"
export npm_config_arch="$ARCH"

# Clean build artifacts if requested
if [[ "$CLEAN" == true ]]; then
    echo "Cleaning build artifacts..."
    docker-compose -f docker/docker-compose.yml run --rm vscode-build npm run clean
fi

# Perform the requested action
case "$ACTION" in
    build)
        echo "Building VSCode for $ARCH architecture..."
        docker-compose -f docker/docker-compose.yml run --rm vscode-build
        ;;
    run)
        echo "Building and running VSCode for $ARCH architecture..."
        docker-compose -f docker/docker-compose.yml run --rm vscode-build

        # Configure X11 for display
        if [[ "$(uname)" == "Linux" ]]; then
            xhost +local:docker
        elif [[ "$(uname)" == "Darwin" ]]; then
            echo "On macOS, make sure XQuartz is running and you've run: xhost +localhost"
        fi

        docker-compose -f docker/docker-compose.yml run --rm vscode-run
        ;;
    dev)
        echo "Running VSCode in development mode for $ARCH architecture..."

        # Configure X11 for display
        if [[ "$(uname)" == "Linux" ]]; then
            xhost +local:docker
        elif [[ "$(uname)" == "Darwin" ]]; then
            echo "On macOS, make sure XQuartz is running and you've run: xhost +localhost"
        fi

        docker-compose -f docker/docker-compose.yml run --rm vscode-dev
        ;;
esac

# Create package if requested
if [[ -n "$PACKAGE" ]]; then
    echo "Creating $PACKAGE package for $ARCH architecture..."
    case "$PACKAGE" in
        deb)
            docker-compose -f docker/docker-compose.yml run --rm vscode-build npm run gulp vscode-linux-$ARCH-build-deb
            ;;
        rpm)
            docker-compose -f docker/docker-compose.yml run --rm vscode-build npm run gulp vscode-linux-$ARCH-build-rpm
            ;;
        snap)
            docker-compose -f docker/docker-compose.yml run --rm vscode-build npm run gulp vscode-linux-$ARCH-prepare-snap
            ;;
        *)
            echo "Error: Invalid package type. Must be one of: deb, rpm, snap"
            exit 1
            ;;
    esac
fi

echo "Done!"

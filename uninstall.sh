#!/bin/bash

# MadMD Uninstaller

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CONTAINER_NAME="madmd"
INSTALL_DIR="$HOME/madmd"

echo -e "${YELLOW}MadMD Uninstaller${NC}"
echo "=================="

# Stop and remove container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "🛑 Stopping MadMD container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    echo -e "${GREEN}✅ Container removed${NC}"
else
    echo "No MadMD container found"
fi

# Remove image
if docker images --format '{{.Repository}}' | grep -q "^madmd$"; then
    echo "🗑️  Removing MadMD image..."
    docker rmi madmd:latest 2>/dev/null || true
    echo -e "${GREEN}✅ Image removed${NC}"
fi

# Remove directory
if [ -d "$INSTALL_DIR" ]; then
    read -p "Remove MadMD directory at $INSTALL_DIR? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
        echo -e "${GREEN}✅ Directory removed${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ MadMD uninstalled successfully${NC}"

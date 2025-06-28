#!/bin/bash

# MadMD One-Click Installer
# This script installs MadMD on your server

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/pzep1/madmd.git"
INSTALL_DIR="$HOME/madmd"
CONTAINER_NAME="madmd"
PORT=8421

echo -e "${GREEN}🚀 MadMD One-Click Installer${NC}"
echo "================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo "Please install Docker first:"
    echo "curl -sSL https://get.docker.com | sh"
    echo "sudo usermod -aG docker $USER"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon is not running!${NC}"
    echo "Please start Docker and try again."
    exit 1
fi

# Check if port is already in use
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port $PORT is already in use${NC}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi
# Clone or update repository
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}📁 MadMD directory already exists${NC}"
    read -p "Update existing installation? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Updating MadMD..."
        cd "$INSTALL_DIR"
        git pull
    else
        echo "Installation cancelled"
        exit 0
    fi
else
    echo "📥 Downloading MadMD..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Stop existing container if running
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}🛑 Stopping existing MadMD container...${NC}"
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
fi

# Build and run with Docker Compose if available
if command -v docker-compose &> /dev/null; then
    echo "🔨 Building with Docker Compose..."
    docker-compose up -d
else
    echo "🔨 Building Docker image..."
    docker build -t madmd:latest .
    
    echo "🏃 Starting MadMD container..."
    docker run -d \
        --name "$CONTAINER_NAME" \
        --restart unless-stopped \
        -p ${PORT}:${PORT} \
        madmd:latest
fi

# Wait for container to start
echo -n "⏳ Waiting for MadMD to start"
for i in {1..10}; do
    if curl -s http://localhost:${PORT} > /dev/null; then
        echo -e "\n${GREEN}✅ MadMD is running!${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
    SERVER_IP="localhost"
fi

# Success message
echo ""
echo "========================================"
echo -e "${GREEN}🎉 MadMD installation complete!${NC}"
echo ""
echo "📱 Access MadMD at:"
echo "   Local: http://localhost:${PORT}"
echo "   Network: http://${SERVER_IP}:${PORT}"
echo ""
echo "📲 On mobile devices:"
echo "   1. Open http://${SERVER_IP}:${PORT}"
echo "   2. Add to Home Screen for PWA app"
echo ""
echo "🔧 Useful commands:"
echo "   View logs: docker logs $CONTAINER_NAME"
echo "   Stop: docker stop $CONTAINER_NAME"
echo "   Start: docker start $CONTAINER_NAME"
echo "   Update: cd $INSTALL_DIR && git pull && docker-compose up -d --build"
echo "========================================"

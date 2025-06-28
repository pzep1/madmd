#!/bin/bash

# MadMD Quick Install - No Git Required
# This script downloads and runs MadMD without cloning the repo

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
GITHUB_USER="pzep1"
GITHUB_REPO="madmd"
CONTAINER_NAME="madmd"
PORT=8421

echo -e "${GREEN}🚀 MadMD Quick Installer${NC}"
echo "========================"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo "Install with: curl -sSL https://get.docker.com | sh"
    exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📥 Downloading MadMD..."

# Download the docker-compose.yml directly
curl -sSL "https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/docker-compose.yml" -o docker-compose.yml

# Create a minimal Dockerfile that pulls from GitHub
cat > Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /usr/src/app

# Install git
RUN apk add --no-cache git

# Clone the repository
RUN git clone https://github.com/pzep1/madmd.git .

# Install dependencies
RUN npm install

EXPOSE 8421
CMD ["node", "server.js"]
EOF

# Replace YOUR_USERNAME in Dockerfile
sed -i "s/YOUR_USERNAME/${GITHUB_USER}/g" Dockerfile
# Stop existing container
docker stop "$CONTAINER_NAME" 2>/dev/null || true
docker rm "$CONTAINER_NAME" 2>/dev/null || true

echo "🔨 Building MadMD..."
docker build -t madmd:latest .

echo "🏃 Starting MadMD..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p ${PORT}:${PORT} \
    madmd:latest

# Wait for startup
echo -n "⏳ Waiting for MadMD"
for i in {1..10}; do
    if curl -s http://localhost:${PORT} > /dev/null 2>&1; then
        echo -e "\n${GREEN}✅ Success!${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Cleanup
cd /
rm -rf "$TEMP_DIR"

# Get IP
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

# Success
echo ""
echo "========================================"
echo -e "${GREEN}🎉 MadMD is running!${NC}"
echo ""
echo "📱 Access at:"
echo "   http://localhost:${PORT}"
echo "   http://${SERVER_IP}:${PORT}"
echo ""
echo "📲 Add to home screen on mobile!"
echo "========================================"

#!/bin/bash

# Raspberry Pi deployment script for MadMD

# Configuration
PI_HOST="admin@192.168.86.41"
REMOTE_DIR="/home/admin/madmd"
CONTAINER_NAME="madmd"
IMAGE_NAME="madmd:latest"
PORT=8421

echo "🚀 Starting deployment to Raspberry Pi..."

# Step 1: Create tarball of the project (excluding node_modules)
echo "📦 Creating project archive..."
tar -czf madmd.tar.gz \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='madmd.tar.gz' \
    .

# Step 2: Copy to Pi
echo "📤 Copying files to Pi..."
ssh $PI_HOST "mkdir -p $REMOTE_DIR"
scp madmd.tar.gz $PI_HOST:$REMOTE_DIR/

# Step 3: Build and run on Pi
echo "🔨 Building and deploying on Pi..."
ssh $PI_HOST << 'EOF'
cd /home/admin/madmd

# Extract files
tar -xzf madmd.tar.gz
rm madmd.tar.gz

# Stop existing container if running
docker stop madmd 2>/dev/null || true
docker rm madmd 2>/dev/null || true

# Build new image
echo "Building Docker image..."
docker build -t madmd:latest .

# Run container with restart policy
echo "Starting container..."
docker run -d \
    --name madmd \
    --restart unless-stopped \
    -p 8421:8421 \
    madmd:latest

# Show status
docker ps | grep madmd
EOF

# Cleanup local archive
rm madmd.tar.gz

echo "✅ Deployment complete!"
echo "🌐 Access MadMD at: http://$PI_HOST:$PORT"
echo "📱 Add to home screen for PWA functionality"

# MadMD - Markdown Normalizer PWA

A Progressive Web App for normalizing and editing Markdown files, designed to run in Docker.

## Features
- Markdown file normalization
- PWA support for mobile devices
- Lightweight Docker deployment
- Easy one-click installation

## Quick Install on Raspberry Pi (or any Linux server)

```bash
curl -sSL https://raw.githubusercontent.com/pzep1/madmd/main/install.sh | bash
```

Or download and review first:
```bash
wget https://raw.githubusercontent.com/pzep1/madmd/main/install.sh
chmod +x install.sh
./install.sh
```

## Manual Installation

### Prerequisites
- Docker installed on your system
- Docker Compose (optional but recommended)

### Using Docker Compose
```bash
git clone https://github.com/pzep1/madmd.git
cd madmd
docker-compose up -d
```

### Using Docker
```bash
git clone https://github.com/pzep1/madmd.git
cd madmd
docker build -t madmd:latest .
docker run -d --name madmd --restart unless-stopped -p 8421:8421 madmd:latest
```

## Access
- Open your browser to `http://YOUR_SERVER_IP:8421`
- Add to home screen on mobile for PWA functionality

## Configuration
- Default port: 8421
- To change the port, edit `docker-compose.yml` or use `-p` flag with docker run

## Development
```bash
npm install
npm start
```

## License
MIT

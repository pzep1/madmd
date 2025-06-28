# MadMD - Markdown Normalizer PWA

A Progressive Web App for normalizing and editing Markdown files, available as both a web app and native desktop application.

## Features
- Markdown file normalization
- Live preview with syntax highlighting
- PWA support for mobile devices
- Native desktop app for Mac, Windows, and Linux
- Lightweight Docker deployment
- Easy one-click installation

## Download Desktop App

### [⬇️ Download MadMD for Mac](https://github.com/pzep1/madmd/releases/latest)
*Also available for Windows and Linux in releases*

The desktop app features:
- Double-click any .md file to open
- Native file system access
- Keyboard shortcuts (⌘S to save, ⌘O to open)
- Works completely offline

## Web Version - Quick Install on Raspberry Pi (or any Linux server)

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

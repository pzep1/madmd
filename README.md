# MadMD - Markdown Editor

A fast, lightweight markdown editor available as both a native desktop app and Docker-based web service. Features live preview, syntax highlighting, and seamless file handling.

## 🚀 Quick Start

### Desktop App (Recommended for personal use)

**[⬇️ Download MadMD Desktop](https://github.com/pzep1/madmd/releases/tag/v1.0.0)**

Available for macOS (Windows and Linux coming soon). The desktop app features:
- ✅ Double-click any `.md` file to edit
- ✅ Native file system integration  
- ✅ Keyboard shortcuts (⌘S to save, ⌘O to open)
- ✅ Works completely offline
- ✅ Set as default markdown editor

### Web Version (For servers/remote access)

Deploy MadMD on any Linux server or Raspberry Pi with one command:

```bash
curl -sSL https://raw.githubusercontent.com/pzep1/madmd/main/quick-install.sh | bash
```

The web version provides:
- 🌐 Access from any device on your network
- 📱 Progressive Web App - install on mobile
- 🐳 Lightweight Docker container
- 🔄 Auto-restart on reboot

## 📋 Features

- **Live Preview** - See formatted markdown as you type
- **Syntax Highlighting** - Beautiful code blocks with highlight.js
- **Clean Interface** - Distraction-free split-pane editor
- **GitHub Styling** - Familiar markdown rendering
- **Improved Readability** - Enhanced typography and spacing

## 🖥️ Desktop Installation

1. Download the `.dmg` file from [releases](https://github.com/pzep1/madmd/releases/tag/v1.0.0)
2. Open the DMG and drag MadMD to Applications
3. Right-click MadMD and select "Open" (first time only)
4. To set as default for `.md` files:
   - Right-click any .md file
   - Get Info (⌘I)
   - Change "Open with" to MadMD
   - Click "Change All..."

## 🐳 Server Installation

### Prerequisites
- Docker installed on your server
- Port 8421 available

### Method 1: Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/pzep1/madmd/main/quick-install.sh | bash
```

### Method 2: Docker Compose
```bash
git clone https://github.com/pzep1/madmd.git
cd madmd
docker-compose up -d
```

### Method 3: Docker Run
```bash
docker run -d \
  --name madmd \
  --restart unless-stopped \
  -p 8421:8421 \
  ghcr.io/pzep1/madmd:latest
```

## 🔧 Development

### Run locally
```bash
git clone https://github.com/pzep1/madmd.git
cd madmd
npm install
npm start  # Runs Electron app
```

### Run web server
```bash
npm run server  # Starts Express server on port 8421
```

### Build desktop app
```bash
npm run build-mac    # macOS
npm run build-win    # Windows  
npm run build-linux  # Linux
```

## 📱 PWA Installation

When running the web version:
1. Open `http://YOUR_SERVER_IP:8421` in mobile browser
2. Add to Home Screen
3. Launch as standalone app

## 🛠️ Configuration

- **Port**: 8421 (configurable in docker-compose.yml)
- **Data**: Files remain on your local system
- **Updates**: Pull latest Docker image or download new release

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## 📞 Support

- [Report issues](https://github.com/pzep1/madmd/issues)
- [View releases](https://github.com/pzep1/madmd/releases)

---

Made with ❤️ for the markdown community

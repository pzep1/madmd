# MadMD Raspberry Pi Deployment

## Prerequisites on your Pi
1. Docker installed: `curl -sSL https://get.docker.com | sh`
2. Add admin user to docker group: `sudo usermod -aG docker admin`
3. Log out and back in for group changes to take effect

## Method 1: Using the deployment script

1. Edit `deploy-to-pi.sh` and update the `PI_HOST` variable with your Pi's IP or hostname
2. Run: `./deploy-to-pi.sh`

## Method 2: Manual deployment with docker-compose

1. Copy the project to your Pi:
   ```bash
   scp -r /Volumes/BigStorage/CodeWorld/MadMD admin@192.168.86.41:/home/admin/
   ```

2. SSH into your Pi:
   ```bash
   ssh admin@192.168.86.41
   ```

3. Navigate to the project and run:
   ```bash
   cd /home/admin/MadMD
   docker-compose up -d
   ```

## Method 3: Manual deployment with Docker

1. On your Pi, after copying files:
   ```bash
   cd /home/admin/MadMD
   docker build -t madmd:latest .
   docker run -d --name madmd --restart unless-stopped -p 8421:8421 madmd:latest
   ```

## Accessing MadMD

- Local network: `http://192.168.86.41:8421`
- Install as PWA: Open in mobile browser and "Add to Home Screen"

## Managing the container

- View logs: `docker logs madmd`
- Stop: `docker stop madmd`
- Start: `docker start madmd`
- Restart: `docker restart madmd`
- Update: Run deployment script again or `docker-compose pull && docker-compose up -d`

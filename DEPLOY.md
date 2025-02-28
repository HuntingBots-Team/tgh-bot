# Deployment Guide

## Local Testing

1. **Setup Environment**:
   ```bash
   # Clone the repository
   git clone https://github.com/yourusername/TGH_Mirror
   cd TGH_Mirror

   # Copy and configure environment variables
   cp config.env.example config.env
   # Edit config.env with your values (BOT_TOKEN, TELEGRAM_API, etc.)
   ```

2. **Test with Docker Locally**:
   ```bash
   # Build the image
   docker-compose build

   # Run the container
   docker-compose up -d

   # Check logs
   docker-compose logs -f
   ```

3. **Debugging**:
   - Check logs for any errors: `docker-compose logs -f`
   - Access services:
     - qBittorrent WebUI: http://localhost:8090 (admin/adminadmin)
     - SABnzbd: http://localhost:8070

4. **Common Issues**:
   - If services fail to start, check port conflicts
   - Ensure all required environment variables are set
   - Check file permissions in mounted volumes

## VPS Deployment

1. **Server Setup**:
   ```bash
   # Update system
   apt update && apt upgrade -y

   # Install Docker and Docker Compose
   apt install docker.io docker-compose -y
   ```

2. **Project Setup**:
   ```bash
   # Clone repository
   git clone https://github.com/yourusername/TGH_Mirror
   cd TGH_Mirror

   # Configure environment
   cp config.env.example config.env
   nano config.env  # Edit with your production values
   ```

3. **Deploy**:
   ```bash
   # Build and start services
   docker-compose up -d --build

   # Monitor logs
   docker-compose logs -f
   ```

4. **Security Considerations**:
   - Change default passwords (qBittorrent, SABnzbd)
   - Use strong BOT_TOKEN and API credentials
   - Configure firewall rules
   - Use HTTPS for web interfaces

5. **Maintenance**:
   ```bash
   # Update containers
   docker-compose pull
   docker-compose up -d

   # Check container status
   docker-compose ps

   # View resource usage
   docker stats
   ```

6. **Backup**:
   - Regularly backup config.env
   - Backup download directories if needed
   - Consider using volume backups

## Troubleshooting

1. **Container Issues**:
   ```bash
   # Check container status
   docker-compose ps

   # View detailed logs
   docker-compose logs -f

   # Restart services
   docker-compose restart
   ```

2. **Common Problems**:
   - Port conflicts: Check if ports are already in use
   - Permission issues: Ensure correct file permissions
   - Network issues: Check firewall settings
   - Resource limits: Monitor CPU/RAM usage

3. **Recovery**:
   ```bash
   # Stop all containers
   docker-compose down

   # Remove all containers and volumes (careful!)
   docker-compose down -v

   # Clean rebuild
   docker-compose up -d --build --force-recreate
   ```

## Best Practices

1. **Testing**:
   - Always test changes locally first
   - Use a staging environment if possible
   - Monitor logs during initial deployment

2. **Updates**:
   - Keep base images updated
   - Regularly update dependencies
   - Test updates in staging before production

3. **Monitoring**:
   - Set up container monitoring
   - Monitor disk space and resource usage
   - Keep logs for troubleshooting

4. **Security**:
   - Change default passwords
   - Use environment variables for secrets
   - Keep systems updated
   - Use firewall rules
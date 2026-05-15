# SIEM System - v1.0.0

A modern, containerized Security Information and Event Management (SIEM) system for real-time security monitoring.

---

## � ZERO-CLICK SETUP (NO GIT NEEDED!)

### Step 1: Download Just One File
Download **only** the `docker-compose.yml` file to your computer:
- **From GitHub**: Go to https://github.com/viraj-gavade/SIEM-System/blob/master/docker-compose.yml → Click "Raw" → Save as `docker-compose.yml`

### Step 2: Run One Command
Open a terminal in the folder where you saved `docker-compose.yml` and run:
```bash
docker-compose up -d
```

### Step 3: Open the Dashboard
Go to: **http://localhost:3000**

That's it! You're done! 🎊

---

## �📋 Table of Contents
- [Features](#-features)
- [Architecture](#-architecture)
- [Docker Images](#-docker-images)
- [Quick Start](#-quick-start)
- [How to Use](#-how-to-use)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Version](#-version)
- [Future Improvements](#-future-improvements)

---

## ✨ Features

### Core Capabilities
- **Real-time Security Monitoring** - Continuous monitoring of container events using Falco
- **Event Correlation Engine** - Automatic incident generation from multiple related events
- **WebSocket Dashboard** - Real-time updates with no polling
- **Incident Deduplication** - Redis-based deduplication with configurable cooldowns
- **24-hour Time Boundary** - All metrics only count events from the last 24 hours
- **Docker Healthcheck Exclusions** - Smart filtering to avoid false positives

### Dashboard Features
- **KPI Cards** - Active Incidents, Total Alerts, Total Logs, Critical Events, Last Event
- **Incident List** - Complete incident history with severity badges and status
- **Event Feed** - Chronological feed of security alerts and events
- **Container Management** - View, monitor, and control Docker containers
- **Cluster Health** - Elasticsearch cluster health and statistics
- **Alert Sounds** - Audio alerts for new incidents (CRITICAL/HIGH/MEDIUM)
- **Popup Notifications** - Toast notifications for new incidents
- **Fullscreen Flash** - Critical incidents trigger fullscreen alert overlay

---

## 🏗️ Architecture

```
┌─────────┐     ┌──────────┐     ┌───────────┐     ┌─────────────┐
│  Falco  │────▶│ Producer │────▶│ Redpanda  │────▶│  Consumer   │
└─────────┘     └──────────┘     └───────────┘     └──────┬──────┘
                                                               │
                                                               ▼
┌──────────────┐     ┌───────────┐     ┌──────────────────┐
│   Dashboard  │◀────│ Websocket │◀────│  Elasticsearch   │
└──────────────┘     └───────────┘     └────────┬─────────┘
                                                    │
                                                    ▼
                                             ┌───────────┐
                                             │   Redis   │
                                             └───────────┘
```

### Components
1. **Falco** - Runtime security monitoring for containers
2. **Producer** - FastAPI webhook receiver that sends events to Redpanda
3. **Redpanda** - Kafka-compatible message broker for event streaming
4. **Consumer** - Correlation engine that processes events and generates incidents
5. **Elasticsearch** - Data storage and search engine
6. **Redis** - Deduplication and state management
7. **WebSocket Server** - Real-time dashboard updates
8. **React Dashboard** - Modern, responsive UI

---

## 🐳 Docker Images

### Using Pre-built Images (v1.0.0)

All v1.0.0 images are available on **Docker Hub** AND **GitHub Container Registry**! No local build needed - just pull and run!

### Image List

#### Docker Hub:
- `virajjs/siem-producer:v1.0.0` - Webhook receiver
- `virajjs/siem-consumer:v1.0.0` - Correlation engine
- `virajjs/siem-websocket:v1.0.0` - WebSocket server
- `virajjs/siem-dashboard:v1.0.0` - React dashboard

#### GitHub Container Registry (ghcr.io):
- `ghcr.io/viraj-gavade/siem-producer:v1.0.0` - Webhook receiver
- `ghcr.io/viraj-gavade/siem-consumer:v1.0.0` - Correlation engine
- `ghcr.io/viraj-gavade/siem-websocket:v1.0.0` - WebSocket server
- `ghcr.io/viraj-gavade/siem-dashboard:v1.0.0` - React dashboard

### Quick Start with Docker Hub Images

The `docker-compose.yml` is already configured to use the Docker Hub images! Just run:

```bash
cd d:\SIEM System
docker-compose up -d
```

This will automatically pull all images from Docker Hub!

### Using GitHub Container Registry Instead

To use GitHub Container Registry instead of Docker Hub, update the image names in `docker-compose.yml` to use the `ghcr.io/viraj-gavade/` prefix.

### Building Images Locally (Optional)

If you want to build the images locally instead of using Docker Hub:

```bash
cd d:\SIEM System
docker-compose build
```

### Pushing to Your Own Registry (Optional)

To push images to your own Docker registry (Docker Hub, GitHub Container Registry, etc.):

```bash
# Tag images
docker tag virajjs/siem-producer:v1.0.0 your-registry/siem-producer:v1.0.0
docker tag virajjs/siem-consumer:v1.0.0 your-registry/siem-consumer:v1.0.0
docker tag virajjs/siem-websocket:v1.0.0 your-registry/siem-websocket:v1.0.0
docker tag virajjs/siem-dashboard:v1.0.0 your-registry/siem-dashboard:v1.0.0

# Push images
docker push your-registry/siem-producer:v1.0.0
docker push your-registry/siem-consumer:v1.0.0
docker push your-registry/siem-websocket:v1.0.0
docker push your-registry/siem-dashboard:v1.0.0
```

Then update `docker-compose.yml` to use your registry images.

---

## 🚀 Quick Start

### Prerequisites
- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose
- At least 4 GB RAM available

### Installation

1. **Clone or navigate to the project directory**:
   ```bash
   cd d:\SIEM System
   ```

2. **Start the system**:
   ```bash
   docker-compose up -d
   ```

3. **Wait for all services to become healthy** (about 1-2 minutes):
   ```bash
   docker-compose ps
   ```

4. **Access the dashboard**:
   - Open your browser and go to: http://localhost:3000

---

## 📖 How to Use the Application

### Step 1: Start the System
```bash
cd d:\SIEM System
docker-compose up -d
```

Wait 1-2 minutes for all services to become healthy, then verify with:
```bash
docker-compose ps
```

### Step 2: Open the Dashboard
Go to **http://localhost:3000** in your browser.

### Step 3: Understand the Dashboard

#### Top Bar
- **Logo & Version**: Shows "SIEM // THREAT INTELLIGENCE" and v1.0.0
- **Test Alert**: Click to simulate a security incident
- **Sound Toggle**: Mute/unmute alert sounds
- **Connection Status**: Green = connected, Red = disconnected
- **Last Refresh**: Time of last data update

#### KPI Cards (2 full rows!)
**Row 1 - Alert Metrics (24h):**
- **Active Incidents**: Number of OPEN/ESCALATED incidents
- **Total Alerts**: Total security alerts
- **Critical/High**: CRITICAL + HIGH severity alerts
- **Medium Alerts**: MEDIUM severity alerts
- **Low/Info**: LOW + INFORMATIONAL alerts

**Row 2 - Incident Metrics (24h):**
- **Total Incidents**: Total correlated incidents
- **Open Incidents**: OPEN status incidents
- **Escalated**: ESCALATED status incidents
- **Resolved**: RESOLVED status incidents
- **Last Event**: Time of most recent event

#### Visualizations
- **Alerts Over Time**: Line chart showing alert frequency (24h)
- **Alert Severity Distribution**: Bar chart showing alerts by severity
- **Incident Status**: Bar chart showing incidents by status (Open/Escalated/Resolved)
- **Network Topology**: Visualization of container relationships

#### Panels
- **Incidents Panel**: List of all security incidents, filterable by severity/status
- **Event Feed**: Chronological feed of all alerts and logs
- **Containers Panel**: List of Docker containers with status indicators
- **Metrics Panels**: Detailed alert and incident metrics
- **System Health**: Elasticsearch cluster health and statistics

### Step 4: Test the System

#### Option 1: Use the Test Alert Button
1. Open http://localhost:3000
2. Click "TEST ALERT" in the top-right
3. You'll see:
   - A popup notification
   - An alert sound (if not muted)
   - The incident in the incidents list
   - Metrics updating in real-time

#### Option 2: Create a Test Container
```bash
# Create a test container
docker run -d --name siem-test-container alpine sleep 3600

# Run suspicious commands to trigger alerts
docker exec siem-test-container sh -c "cat /etc/passwd"
docker exec siem-test-container sh -c "cat /etc/shadow"
docker exec siem-test-container sh -c "apk add curl"

# Clean up when done
docker stop siem-test-container
docker rm siem-test-container
```

#### Option 3: Send a Test Alert via API
```powershell
# Send a CRITICAL alert
$criticalAlert = @{
    rule = "Critical Security Alert"
    priority = "CRITICAL"
    output = "Suspicious activity detected!"
    output_fields = @{
        "container.id" = "test-001"
        "container.name" = "test-container"
    }
}
Invoke-RestMethod -Uri "http://localhost:5140/falco" -Method Post -Body ($criticalAlert | ConvertTo-Json) -ContentType "application/json"

# Send a HIGH alert
$highAlert = @{
    rule = "High Security Alert"
    priority = "HIGH"
    output = "Potentially malicious activity detected!"
    output_fields = @{
        "container.id" = "test-002"
        "container.name" = "test-container"
    }
}
Invoke-RestMethod -Uri "http://localhost:5140/falco" -Method Post -Body ($highAlert | ConvertTo-Json) -ContentType "application/json"
```

### Step 5: Monitor Your Containers
- The dashboard automatically monitors all Docker containers
- Any suspicious activity (shell spawn, sensitive file access, etc.) will trigger alerts
- Alerts are correlated into incidents automatically

### Step 6: View Logs
To view logs for any service:
```bash
# View logs for a specific service
docker-compose logs -f <service-name>

# Available services:
# - falco
# - producer
# - redpanda
# - consumer
# - elasticsearch
# - redis
# - websocket-server
# - dashboard
```

---

## 🧪 Testing the System

---

## 🔧 Troubleshooting

### Common Issues

#### **Dashboard shows "Connection Lost"**
- Check if the websocket-server container is running: `docker-compose ps websocket-server`
- Check websocket-server logs: `docker-compose logs websocket-server`
- Make sure port 8765 is not blocked

#### **No alerts showing up**
- Check if Falco is running: `docker-compose ps falco`
- Check producer logs: `docker-compose logs producer`
- Check consumer logs: `docker-compose logs consumer`
- Verify Elasticsearch is healthy: `docker-compose ps elasticsearch`

#### **Old incidents keep appearing**
- This was fixed in v1.0.0! Make sure you're on the latest version
- If issues persist, try clearing data: `docker-compose down -v && docker-compose up -d`

#### **High CPU/Memory usage**
- This is normal for Elasticsearch - it's a resource-intensive application
- Make sure you have at least 4 GB RAM allocated to Docker
- You can limit resources in docker-compose.yml if needed

### Useful Commands

```bash
# Check status of all services
docker-compose ps

# View logs for a specific service
docker-compose logs -f <service-name>  # -f = follow (stream)
docker-compose logs --tail 50 <service-name>  # last 50 lines

# Available services:
# - falco
# - producer
# - redpanda
# - consumer
# - elasticsearch
# - redis
# - websocket-server
# - dashboard

# Restart a specific service
docker-compose restart <service-name>

# Stop the entire system
docker-compose down

# Stop the system and delete all data
docker-compose down -v

# Rebuild and restart a service
docker-compose up -d --build <service-name>
```

---

## 📦 Version

**Current Version**: v1.0.0

See `RELEASE_NOTES.md` for detailed release notes and changelog.

---

## 🔮 Future Improvements

We have big plans for future versions! Check out `IMPROVEMENTS.md` for our complete roadmap, including:

### Quick Wins (Coming Soon)
- Slack/PagerDuty notifications
- More correlation rules
- PDF report generation
- Basic RBAC (Role-Based Access Control)

### Advanced Features
- MITRE ATT&CK integration
- Threat intelligence feeds
- Automated response playbooks
- User authentication
- Compliance reporting (GDPR, HIPAA, PCI)
- Machine learning for anomaly detection
- And much more!

---

## 🤝 Contributing

Found a bug or want to contribute? Great! Please:

1. Check the issues to see if it's already reported
2. Create a new issue if needed
3. Submit a pull request with your changes

---

## 📄 License

This project is provided as-is for educational and security monitoring purposes.

---

## 🛡️ Stay Secure!

Remember: This is a security tool - always use it responsibly and in accordance with your organization's policies and applicable laws.

---

**Thank you for using our SIEM System!** 🎉


# Prometheus & Grafana Monitoring Stack

Self-hosted monitoring stack for AMAZ Healthcare platform.

## Architecture

**Two Deployment Modes:**

1. **Single Server** - All-in-one setup (use `docker-compose.yml`)
2. **Multi-Server** - Centralized monitoring (use `docker-compose.monitoring.yml` + `docker-compose.node.yml`)

### Multi-Server Architecture

**Monitoring Server (192.168.100.71)**
- Prometheus (port 1090)
- Grafana (port 1300)
- Node Exporter (port 9100)
- cAdvisor (port 8080)

**Node Server(s) (192.168.100.56, ...)**
- Node Exporter (port 9100)
- cAdvisor (port 8080)

## Quick Start

### Single Server Deployment

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down
```

### Multi-Server Deployment

**On each node server (192.168.100.56, etc.):**
```bash
docker compose -f docker-compose.node.yml up -d
```

**On monitoring server (192.168.100.71):**
```bash
# Start exporters
docker compose -f docker-compose.node.yml up -d

# Start monitoring stack
docker compose -f docker-compose.monitoring.yml up -d
```

## Access URLs

- **Prometheus**: http://192.168.100.71:1090 (or localhost:1090)
- **Grafana**: http://192.168.100.71:1300 (or localhost:1300)

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize ports, credentials, and refresh intervals.

### Multi-Server Setup

Edit `prometheus.yml` to add more servers:

```yaml
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets:
          - '192.168.100.71:9100'
          - '192.168.100.56:9100'
          - '192.168.100.XX:9100'  # Add new servers here
```

Reload config: `curl -X POST http://localhost:1090/-/reload`

### Grafana Dashboards

**Import Node Exporter Full (ID: 1860):**

1. Access Grafana → **Dashboards** → **Import**
2. Enter: `1860` → **Load**
3. Select **Prometheus** datasource → **Import**

**Other recommended dashboards:**
- **893**: Docker and System Monitoring
- **14282**: cAdvisor exporter
- **2**: Prometheus Stats

## Firewall Configuration

**On all servers with exporters:**
```bash
sudo ufw allow 9100/tcp comment 'Node Exporter'
sudo ufw allow 8080/tcp comment 'cAdvisor'
```

**On monitoring server (if external access needed):**
```bash
sudo ufw allow 1090/tcp comment 'Prometheus'
sudo ufw allow 1300/tcp comment 'Grafana'
```

## Troubleshooting

**Check Prometheus targets**: http://localhost:1090/targets (all should be UP)

**Test exporter from monitoring server:**
```bash
curl http://192.168.100.56:9100/metrics
curl http://192.168.100.56:8080/metrics
```

**Verify network connectivity:**
```bash
ping 192.168.100.56
telnet 192.168.100.56 9100
```

**Reload Prometheus config:**
```bash
curl -X POST http://localhost:1090/-/reload
```

## Files

- `docker-compose.yml` - Single server setup
- `docker-compose.monitoring.yml` - Prometheus + Grafana only
- `docker-compose.node.yml` - Exporters only (uses host network)
- `prometheus.yml` - Scrape configuration
- `.env` - Environment variables

## Data Persistence

Data stored in Docker volumes:
- `prometheus-data`: Metrics (30 days retention)
- `grafana-data`: Dashboards and configurations

## Security

⚠️ For production:
- Change `GRAFANA_ADMIN_PASSWORD` in `.env`
- Don't commit `.env` to git
- Use reverse proxy with HTTPS
- Enable firewall rules
- Restrict Prometheus/Grafana access

## Notes

- Multi-server setup uses `network_mode: host` for accurate metrics
- Default ports: Prometheus=1090, Grafana=1300, Node Exporter=9100, cAdvisor=8080
- Grafana auto-refresh: 5 seconds
- Prometheus scrape interval: 15 seconds
- Data retention: 30 days
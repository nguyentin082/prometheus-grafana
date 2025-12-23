# Prometheus & Grafana Monitoring Stack

Self-hosted monitoring stack for AMAZ Healthcare platform.

## Services

- **Prometheus** (port 1090): Time-series database for metrics collection
- **Grafana** (port 1300): Visualization and dashboards
- **Node Exporter** (port 1100): System metrics (CPU, RAM, disk, network)
- **cAdvisor** (port 1081): Container metrics

## Quick Start

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f
```

## Access URLs

- **Prometheus**: http://localhost:1090
- **Grafana**: http://localhost:1300 (credentials in `.env`)
- **Node Exporter**: http://localhost:1100/metrics
- **cAdvisor**: http://localhost:1081

## Configuration

Copy `.env.example` to `.env` and customize as needed. All ports, credentials, and refresh intervals are configured via environment variables.

### Prometheus Targets

Default monitored services:
- Prometheus self-monitoring
- Node Exporter (system metrics)
- cAdvisor (container metrics)
- AI Core application (host.docker.internal:8080)
- API System (host.docker.internal:3000)

To add custom targets, edit `prometheus.yml` and reload:
```bash
curl -X POST http://localhost:1090/-/reload
```

### Grafana Dashboards

Recommended dashboard IDs to import:
- **1860**: Node Exporter Full
- **893**: Docker and System Monitoring
- **14282**: cAdvisor exporter
- **2**: Prometheus Stats

Import via: Grafana UI → **+** → **Import dashboard** → Enter ID

## Data Persistence

Data stored in Docker volumes:
- `prometheus-data`: Metrics (30 days retention)
- `grafana-data`: Dashboards and configurations

## Troubleshooting

**Check Prometheus targets status**: http://localhost:1090/targets

**Grafana can't connect to Prometheus**:
```bash
docker-compose restart grafana
```

**Port conflicts**: Change ports in `.env` file and restart services.

## Security

⚠️ For production:
- Change `GRAFANA_ADMIN_PASSWORD` in `.env`
- Don't commit `.env` to git
- Use reverse proxy with HTTPS
- Enable firewall rules

## Notes

- All ports use 1xxx range to avoid conflicts
- Grafana auto-refresh: 5 seconds (default)
- Prometheus scrape interval: 15 seconds
- Data retention: 30 days
- Use `host.docker.internal:PORT` for host machine services
# Prometheus & Grafana Monitoring Stack

Self-hosted monitoring stack cho AMAZ Healthcare platform.

## Services

- **Prometheus** (port 9090): Time-series database thu thập metrics
- **Grafana** (port 3000): Visualization và dashboards
- **Node Exporter** (port 9100): System metrics (CPU, RAM, disk, network)
- **cAdvisor** (port 8081): Container metrics (Docker containers)

## Quick Start

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Stop and remove volumes (data will be lost)
docker-compose down -v
```

## Access URLs

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)
- Node Exporter: http://localhost:9100/metrics
- cAdvisor: http://localhost:8081

## Configuration

### Prometheus

File cấu hình: `prometheus.yml`

Các targets được monitor:
- Prometheus self-monitoring
- Node Exporter (system metrics)
- cAdvisor (container metrics)
- AI Core application (port 8080)
- API System (port 3000)

### Grafana

- **Default credentials**: admin/admin
- **Data source**: Prometheus được tự động cấu hình
- **Dashboards**: Có thể import từ [Grafana Dashboards](https://grafana.com/grafana/dashboards/)

Recommended dashboards:
- Node Exporter Full: ID 1860
- Docker and System Monitoring: ID 893
- Prometheus Stats: ID 2

### Adding Custom Metrics

Để monitor thêm services, thêm vào `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'your-service'
    static_configs:
      - targets: ['host:port']
    metrics_path: '/metrics'
```

## Data Persistence

Data được lưu trong Docker volumes:
- `prometheus-data`: Prometheus time-series data (retention: 30 days)
- `grafana-data`: Grafana dashboards và configurations

## Notes

- Prometheus được cấu hình retention 30 ngày
- Để connect tới services trên host machine, sử dụng `host.docker.internal`
- Default scrape interval: 15 giây
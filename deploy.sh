#!/bin/bash
# Run this script on 192.168.100.71

echo "=== Stopping old containers ==="
docker compose down 2>/dev/null
docker stop node-exporter cadvisor 2>/dev/null
docker rm node-exporter cadvisor 2>/dev/null

echo ""
echo "=== Starting node exporters with host network ==="
docker compose -f docker-compose.node.yml up -d

echo ""
echo "=== Waiting 5 seconds ==="
sleep 5

echo ""
echo "=== Testing node-exporter on port 9100 ==="
curl -s http://localhost:9100/metrics | head -5

echo ""
echo "=== Testing cAdvisor on port 8080 ==="
curl -s http://localhost:8080/metrics | head -5

echo ""
echo "=== Starting monitoring stack ==="
docker compose -f docker-compose.monitoring.yml up -d

echo ""
echo "=== Waiting 10 seconds ==="
sleep 10

echo ""
echo "=== Checking Prometheus targets ==="
curl -s http://localhost:1090/api/v1/targets | grep -A 5 '"health"'

echo ""
echo "=== Done! Check targets at: http://192.168.100.71:1090/targets ==="

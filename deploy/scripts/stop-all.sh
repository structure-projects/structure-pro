#!/bin/bash

# Structure Cloud Pro - 停止所有服务

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 停止所有服务"
echo "================================================"
echo ""

cd "$DOCKER_COMPOSE_DIR"

# 1. 停止应用系统
echo "🟨 停止应用系统..."
cd apps
for dir in */; do
    if [ -f "${dir}docker-compose.yaml" ]; then
        echo "  停止 ${dir}..."
        docker-compose -f "${dir}docker-compose.yaml" down || true
    fi
done
cd ..

# 2. 停止原子服务
echo "🟨 停止原子服务..."
cd atom
for dir in */; do
    if [ -f "${dir}docker-compose.yaml" ]; then
        echo "  停止 ${dir}..."
        docker-compose -f "${dir}docker-compose.yaml" down || true
    fi
done
cd ..

# 3. 停止基础服务
echo "🟨 停止基础服务..."
cd basic
SERVICES=(
    "kong-gateway"
    "sentinel-dashboard"
    "logstash-kibana"
    "alertmanager-grafana"
    "skywalking"
    "nacos"
    "rabbitmq"
    "kafka"
    "mysql"
    "redis"
    "elasticsearch"
    "prometheus"
)

for service in "${SERVICES[@]}"; do
    if [ -f "${service}/docker-compose.yml" ]; then
        echo "  停止 ${service}..."
        docker-compose -f "${service}/docker-compose.yml" down || true
    elif [ -f "${service}/docker-compose.yaml" ]; then
        echo "  停止 ${service}..."
        docker-compose -f "${service}/docker-compose.yaml" down || true
    fi
done
cd ..

echo ""
echo "🧹 移除网络..."
docker network rm structure-cloud-work 2>/dev/null || true

echo ""
echo "================================================"
echo " 🛑 所有服务已停止！"
echo "================================================"
echo ""
echo "如需清理数据，运行: ./deploy/scripts/clean-all-data.sh"
echo ""

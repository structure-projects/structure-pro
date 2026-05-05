#!/bin/bash

# Structure Cloud Pro - Docker Compose 本地开发环境快速启动脚本

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 本地开发环境快速启动"
echo "================================================"
echo ""

# 检查 Docker 和 Docker Compose 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    if ! command -v docker compose &> /dev/null; then
        echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
        exit 1
    fi
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

# 创建网络
echo "📦 创建网络..."
docker network create structure-cloud-work --driver overlay 2>/dev/null || true

cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "🚀 启动基础服务..."
cd basic

# 1. 存储服务
echo "  [1/8] 启动 Prometheus..."
$DOCKER_COMPOSE_CMD -f prometheus/docker-compose.yml up -d --wait

echo "  [2/8] 启动 Elasticsearch..."
$DOCKER_COMPOSE_CMD -f elasticsearch/docker-compose.yml up -d --wait

echo "  [3/8] 启动 Redis..."
$DOCKER_COMPOSE_CMD -f redis/docker-compose.yml up -d --wait

echo "  [4/8] 启动 MySQL..."
$DOCKER_COMPOSE_CMD -f mysql/docker-compose.yml up -d --wait

# 2. 消息队列
echo "  [5/8] 启动 Kafka..."
$DOCKER_COMPOSE_CMD -f kafka/docker-compose.yml up -d --wait

echo "  [6/8] 启动 RabbitMQ..."
$DOCKER_COMPOSE_CMD -f rabbitmq/docker-compose.yml up -d --wait

# 3. 注册与配置中心
echo "  [7/8] 启动 Nacos..."
$DOCKER_COMPOSE_CMD -f nacos/docker-compose.yml up -d --wait

# 4. 可观测性服务
echo "  [8/8] 启动可观测性服务..."
$DOCKER_COMPOSE_CMD -f skywalking/docker-compose.yml up -d --wait
$DOCKER_COMPOSE_CMD -f alertmanager-grafana/docker-compose.yml up -d --wait
$DOCKER_COMPOSE_CMD -f logstash-kibana/docker-compose.yml up -d --wait

# 5. 限流熔断与网关
echo "  启动 Sentinel Dashboard..."
$DOCKER_COMPOSE_CMD -f sentinel-dashboard/docker-compose.yml up -d --wait

echo "  启动 Kong Gateway..."
$DOCKER_COMPOSE_CMD -f kong-gateway/docker-compose.yml up -d --wait

cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "================================================"
echo " 🎉 基础服务启动完成！"
echo "================================================"
echo ""
echo "📋 服务访问地址："
echo "  Nacos 控制台: http://localhost:8848/nacos (nacos/nacos)"
echo "  SkyWalking UI: http://localhost:8080"
echo "  Grafana: http://localhost:3000 (admin/admin123)"
echo "  Kibana: http://localhost:5601"
echo "  Sentinel Dashboard: http://localhost:8858 (sentinel/sentinel)"
echo "  Kong Admin: http://localhost:8001"
echo ""
echo "📂 下一个步骤："
echo "  启动原子服务: ./deploy/scripts/start-atom-services.sh"
echo "  查看部署状态: docker ps"
echo ""
echo "================================================"

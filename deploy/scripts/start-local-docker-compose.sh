#!/bin/bash

# Structure Cloud Pro - Docker Compose 本地开发环境快速启动脚本

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/docker-compose"

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

# 1. 存储服务
echo "  [1/12] 启动 Prometheus..."
cd basic/prometheus
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [2/12] 启动 Elasticsearch..."
cd basic/elasticsearch
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [3/12] 启动 Redis..."
cd basic/redis
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [4/12] 启动 MySQL..."
cd basic/mysql
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

# 2. 消息队列
echo "  [5/12] 启动 Kafka..."
cd basic/kafka
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [6/12] 启动 RabbitMQ..."
cd basic/rabbitmq
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

# 3. 注册与配置中心
echo "  [7/12] 启动 Nacos..."
cd basic/nacos
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

# 4. 可观测性服务
echo "  [8/12] 启动 SkyWalking..."
cd basic/skywalking
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [9/12] 启动 AlertManager & Grafana..."
cd basic/alertmanager-grafana
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [10/12] 启动 Logstash & Kibana..."
cd basic/logstash-kibana
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

# 5. 限流熔断与网关
echo "  [11/12] 启动 Sentinel Dashboard..."
cd basic/sentinel-dashboard
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [12/12] 启动 Kong Gateway..."
cd basic/kong-gateway
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

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
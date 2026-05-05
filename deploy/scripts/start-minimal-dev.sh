#!/bin/bash

# Structure Cloud Pro - 最小化开发环境启动脚本
# 只启动必要的核心服务：Nacos、MySQL、Redis、RabbitMQ、Prometheus、Grafana

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 最小化开发环境启动"
echo "================================================"
echo ""

# 检查 Docker 和 Docker Compose
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
echo "🚀 启动核心基础服务..."
cd basic

# 1. 存储服务
echo "  [1/6] 启动 Prometheus..."
$DOCKER_COMPOSE_CMD -f prometheus/docker-compose.yml up -d --wait

echo "  [2/6] 启动 MySQL..."
$DOCKER_COMPOSE_CMD -f mysql/docker-compose.yml up -d --wait

echo "  [3/6] 启动 Redis..."
$DOCKER_COMPOSE_CMD -f redis/docker-compose.yml up -d --wait

# 2. 消息队列
echo "  [4/6] 启动 RabbitMQ..."
$DOCKER_COMPOSE_CMD -f rabbitmq/docker-compose.yml up -d --wait

# 3. 注册与配置中心
echo "  [5/6] 启动 Nacos..."
$DOCKER_COMPOSE_CMD -f nacos/docker-compose.yml up -d --wait

# 4. 基础监控
echo "  [6/6] 启动 Grafana..."
$DOCKER_COMPOSE_CMD -f alertmanager-grafana/docker-compose.yml up -d --wait

cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "================================================"
echo " 🎉 最小化开发环境启动完成！"
echo "================================================"
echo ""
echo "📋 服务访问地址："
echo "  Nacos 控制台: http://localhost:8848/nacos (nacos/nacos)"
echo "  Grafana: http://localhost:3000 (admin/admin123)"
echo ""
echo "📝 说明："
echo "  本环境只启动了开发必需的核心服务"
echo "  如需完整环境，运行: ./deploy/scripts/start-full-dev.sh"
echo ""
echo "================================================"

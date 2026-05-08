#!/bin/bash

# Structure Cloud Pro - 仅可观测性服务启动脚本
# 专门用于监控和调试环境

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 可观测性服务启动"
echo "================================================"
echo ""
echo "本脚本只启动可观测性相关组件："
echo "  - Prometheus (指标监控)"
echo "  - AlertManager (告警)"
echo "  - Grafana (可视化)"
echo "  - SkyWalking (链路追踪)"
echo "  - Elasticsearch (日志存储)"
echo "  - Logstash (日志收集)"
echo "  - Kibana (日志查询)"
echo ""

read -p "确认继续？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消"
    exit 1
fi

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
echo "🚀 启动可观测性服务..."

# 1. 基础存储
echo "  [1/4] 启动 Prometheus..."
cd basic/prometheus
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [2/4] 启动 Elasticsearch..."
cd basic/elasticsearch
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

# 2. 可观测性完整组件
echo "  [3/4] 启动 SkyWalking..."
cd basic/skywalking
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

echo "  [4/4] 启动完整日志和监控系统..."
cd basic/alertmanager-grafana
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

cd basic/logstash-kibana
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait
cd ../..

cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "================================================"
echo " 📊 可观测性服务启动完成！"
echo "================================================"
echo ""
echo "🖥️  系统访问地址："
echo "  Prometheus: http://localhost:9090"
echo "  AlertManager: http://localhost:9093"
echo "  Grafana: http://localhost:3000 (admin/admin123)"
echo "  SkyWalking UI: http://localhost:8080"
echo "  Elasticsearch: http://localhost:9200"
echo "  Kibana: http://localhost:5601"
echo ""
echo "📝 说明："
echo "  1. 此环境用于监控调试"
echo "  2. 可连接已有的业务服务"
echo "  3. 需配置应用上报指标和日志"
echo ""
echo "================================================"
#!/bin/bash

# Structure Cloud Pro - 应用系统快速启动脚本

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 应用系统启动"
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

cd "$DOCKER_COMPOSE_DIR"

echo "🚀 启动应用系统..."

# 1. 内容管理系统
echo "  [1/2] 启动 Content Manager System..."
cd apps/content-manager-system
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

# 2. 管理系统
echo "  [2/2] 启动 Manager System..."
cd apps/manager-system
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "================================================"
echo " 🎉 应用系统启动完成！"
echo "================================================"
echo ""
echo "📂 下一个步骤："
echo "  查看部署状态: docker ps"
echo "  查看服务日志: docker logs <容器名>"
echo ""
echo "================================================"
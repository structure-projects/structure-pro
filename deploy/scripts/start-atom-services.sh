#!/bin/bash

# Structure Cloud Pro - 原子服务快速启动脚本

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 原子服务启动"
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

cd "$DOCKER_COMPOSE_DIR/atom"

echo "🚀 启动原子服务..."

# 1. 用户中心
echo "  [1/5] 启动 User Center..."
$DOCKER_COMPOSE_CMD -f user-center/docker-compose.yaml up -d --wait || true

# 2. 认证授权中心
echo "  [2/5] 启动 OAuth Center..."
$DOCKER_COMPOSE_CMD -f oauth-center/docker-compose.yaml up -d --wait || true

# 3. 内容中心
echo "  [3/5] 启动 Content Center..."
$DOCKER_COMPOSE_CMD -f content-center/docker-compose.yaml up -d --wait || true

# 4. 任务调度中心
echo "  [4/5] 启动 Job Center..."
$DOCKER_COMPOSE_CMD -f job-center/docker-compose.yaml up -d --wait || true

# 5. 管理中心
echo "  [5/5] 启动 Admin Center..."
$DOCKER_COMPOSE_CMD -f admin-center/docker-compose.yaml up -d --wait || true

cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "================================================"
echo " 🎉 原子服务启动完成！"
echo "================================================"
echo ""
echo "📂 下一个步骤："
echo "  启动应用系统: ./deploy/scripts/start-apps.sh"
echo "  查看部署状态: docker ps"
echo ""
echo "================================================"

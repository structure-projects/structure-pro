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

cd "$DOCKER_COMPOSE_DIR"

echo "🚀 启动原子服务..."

# 1. 用户中心
echo "  [1/5] 启动 User Center..."
cd atom/user-center
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

# 2. 认证授权中心
echo "  [2/5] 启动 OAuth Center..."
cd atom/oauth-center
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

# 3. 内容中心
echo "  [3/5] 启动 Content Center..."
cd atom/content-center
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

# 4. 任务调度中心
echo "  [4/5] 启动 Job Center..."
cd atom/job-center
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

# 5. 管理中心
echo "  [5/5] 启动 Admin Center..."
cd atom/admin-center
sh ./scripts/init.sh
$DOCKER_COMPOSE_CMD up -d --wait || true
cd ../..

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
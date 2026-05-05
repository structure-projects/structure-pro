#!/bin/bash

# Structure Cloud Pro - 清理所有数据（警告：不可逆操作！）

read -p "⚠️  警告：此操作将删除所有数据和配置，是否继续？ (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ 操作已取消"
    exit 0
fi

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 清理所有数据"
echo "================================================"
echo ""

# 先停止所有服务
bash "$PROJECT_ROOT/deploy/scripts/stop-all.sh"

cd "$DOCKER_COMPOSE_DIR"

# 清理数据卷
echo "🧹 清理数据卷..."

# 清理基础服务数据
cd basic
for dir in */; do
    if [ -d "${dir}data" ]; then
        echo "  删除 ${dir}data/..."
        rm -rf "${dir}data"
    fi
    if [ -d "${dir}logs" ]; then
        echo "  删除 ${dir}logs/..."
        rm -rf "${dir}logs"
    fi
done

echo ""
echo "🗑️  清理 Docker 未使用的镜像和卷..."
read -p "是否清理 Docker 未使用的卷和镜像？ (yes/no): " docker_confirm
if [ "$docker_confirm" == "yes" ]; then
    docker volume prune -f
    docker image prune -f
fi

echo ""
echo "================================================"
echo " ✅ 所有数据已清理完成！"
echo "================================================"

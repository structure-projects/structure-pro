#!/bin/bash

# Structure Cloud Pro - 一键重置环境脚本
# 停止所有服务，清理数据，重新启动

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 一键重置环境"
echo "================================================"
echo ""
echo "⚠️  警告："
echo "  此操作会："
echo "  1. 停止所有运行中的服务"
echo "  2. 删除所有持久化数据"
echo "  3. 重新启动整个环境"
echo ""

read -p "确认重置？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消"
    exit 1
fi

echo ""

# 1. 停止所有服务
echo "🟥 正在停止所有服务..."
bash "$PROJECT_ROOT/scripts/stop-all.sh"

# 2. 清理所有数据
echo ""
echo "🗑️  正在清理所有数据..."
bash "$PROJECT_ROOT/scripts/clean-all-data.sh"

# 3. 等待清理完成
echo ""
echo "⏳ 等待系统稳定（5秒）..."
sleep 5

# 4. 重新启动环境
echo ""
echo "🔄 正在重新启动完整开发环境..."
bash "$PROJECT_ROOT/scripts/start-full-dev.sh"

echo ""
echo "================================================"
echo " 🔄 环境重置完成！"
echo "================================================"
echo ""
echo "环境已重置到初始状态"
echo ""

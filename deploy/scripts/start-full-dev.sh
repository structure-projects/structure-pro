#!/bin/bash

# Structure Cloud Pro - Docker Compose 开发环境完整一键启动

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 开发环境完整启动"
echo "================================================"
echo ""

cd "$PROJECT_ROOT"

# 1. 启动基础服务
echo "▶️  第一步：启动基础服务..."
bash deploy/scripts/start-local-docker-compose.sh

# 2. 等待 Nacos 完全启动
echo ""
echo "⏳ 等待 Nacos 完全启动（30秒）..."
sleep 30

# 3. 启动原子服务
echo ""
echo "▶️  第二步：启动原子服务..."
bash deploy/scripts/start-atom-services.sh

# 4. 启动应用系统
echo ""
echo "▶️  第三步：启动应用系统..."
bash deploy/scripts/start-apps.sh

echo ""
echo "================================================"
echo " 🎉🎊 恭喜！所有服务已启动！"
echo "================================================"
echo ""
echo "🌐 系统访问地址："
echo "  Nacos 控制台: http://localhost:8848/nacos (nacos/nacos)"
echo "  SkyWalking UI: http://localhost:8080"
echo "  Grafana: http://localhost:3000 (admin/admin123)"
echo "  Kibana: http://localhost:5601"
echo "  Sentinel Dashboard: http://localhost:8858 (sentinel/sentinel)"
echo "  Kong Admin: http://localhost:8001"
echo ""
echo "🛠️  常用运维命令："
echo "  docker ps - 查看运行的容器"
echo "  docker logs -f <容器名> - 查看实时日志"
echo "  ./deploy/scripts/stop-all.sh - 停止所有服务"
echo ""
echo "================================================"

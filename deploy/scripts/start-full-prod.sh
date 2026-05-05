#!/bin/bash

# Structure Cloud Pro - 完整生产环境准备启动脚本
# 包括所有可观测性、监控、告警和安全组件

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 生产环境完整启动"
echo "================================================"
echo ""
echo "⚠️  注意："
echo "  生产环境部署前请检查："
echo "  1. 网络配置正确"
echo "  2. 存储卷已准备"
echo "  3. 资源配置足够"
echo "  4. 安全凭证已更新"
echo ""

read -p "确认继续？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消"
    exit 1
fi

echo ""
cd "$PROJECT_ROOT"

# 1. 启动基础设施
echo "▶️  第一步：启动基础服务..."
bash deploy/scripts/start-local-docker-compose.sh

# 2. 等待服务准备
echo ""
echo "⏳ 等待基础服务稳定（60秒）..."
sleep 60

# 3. 检查服务健康状态
echo ""
echo "✅ 检查服务健康状态..."
docker ps --filter "name=structure" --format "table {{.Names}}\t{{.Status}}"

# 4. 启动原子服务
echo ""
echo "▶️  第二步：启动原子服务..."
bash deploy/scripts/start-atom-services.sh

# 5. 启动应用系统
echo ""
echo "▶️  第三步：启动应用系统..."
bash deploy/scripts/start-apps.sh

# 6. 启动状态汇总
echo ""
echo "================================================"
echo " 🚀 所有服务部署完成！"
echo "================================================"
echo ""
echo "🖥️  系统访问地址："
echo "  Nacos 控制台: http://localhost:8848/nacos (nacos/nacos)"
echo "  SkyWalking UI: http://localhost:8080"
echo "  Grafana: http://localhost:3000 (admin/admin123)"
echo "  Kibana: http://localhost:5601"
echo "  Sentinel Dashboard: http://localhost:8858 (sentinel/sentinel)"
echo "  Kong Admin: http://localhost:8001"
echo ""
echo "🔒 安全提示："
echo "  1. 请立即修改默认密码"
echo "  2. 配置 HTTPS 访问"
echo "  3. 启用安全组/防火墙"
echo "  4. 配置日志轮转和备份"
echo ""
echo "🛠️  常用运维命令："
echo "  docker ps - 查看运行的容器"
echo "  docker stats - 查看资源使用"
echo "  docker logs -f <容器名> - 查看实时日志"
echo "  ./deploy/scripts/stop-all.sh - 停止所有服务"
echo ""
echo "================================================"

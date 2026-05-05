#!/bin/bash

# Structure Cloud Pro - 查看所有服务状态脚本

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "================================================"
echo " Structure Cloud Pro - 服务状态检查"
echo "================================================"
echo ""

echo "🟢 运行中的容器："
echo "----------------------------------------"
docker ps --filter "name=structure" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🔴 停止的容器："
echo "----------------------------------------"
docker ps -a --filter "name=structure" --filter "status=exited" --format "table {{.Names}}\t{{.Status}}"

echo ""
echo "📊 资源使用情况："
echo "----------------------------------------"
docker stats --no-stream --filter "name=structure" --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

echo ""
echo "🌐 网络："
echo "----------------------------------------"
docker network ls --filter "name=structure-cloud-work" --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"

echo ""
echo "================================================"
echo " 📋 检查完成！"
echo "================================================"
echo ""
echo "🔗 快速访问链接："
echo "  Nacos: http://localhost:8848/nacos"
echo "  SkyWalking: http://localhost:8080"
echo "  Grafana: http://localhost:3000"
echo "  Kibana: http://localhost:5601"
echo ""

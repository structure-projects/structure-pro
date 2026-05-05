#!/bin/bash

# Structure Cloud Pro - Kubernetes 开发环境快速部署

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HELM_DIR="$PROJECT_ROOT/deploy/helm"

echo "================================================"
echo " Structure Cloud Pro - Kubernetes 开发环境部署"
echo "================================================"
echo ""

# 检查 kubectl 和 Helm 是否安装
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl 未安装，请先安装 kubectl"
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "❌ Helm 未安装，请先安装 Helm"
    exit 1
fi

# 创建命名空间
echo "📦 创建命名空间..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace logging --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace istio-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace middleware --dry-run=client -o yaml | kubectl apply -f -

cd "$HELM_DIR"

echo ""
echo "🚀 部署基础服务..."
cd basic

# 1. 存储服务
echo "  [1/8] 部署 Prometheus..."
helm install prometheus prometheus -n monitoring --wait || true

echo "  [2/8] 部署 Elasticsearch..."
helm install elasticsearch elasticsearch -n logging --wait || true

echo "  [3/8] 部署 Redis..."
helm install redis redis -n middleware --wait || true

echo "  [4/8] 部署 MySQL..."
helm install mysql mysql -n middleware --wait || true

# 2. 消息队列
echo "  [5/8] 部署 Kafka..."
helm install kafka kafka -n middleware --wait || true

echo "  [6/8] 部署 RabbitMQ..."
helm install rabbitmq rabbitmq -n middleware --wait || true

# 3. 注册与配置中心
echo "  [7/8] 部署 Nacos..."
helm install nacos nacos -n middleware --wait || true

# 4. 可观测性服务
echo "  [8/8] 部署可观测性服务..."
helm install skywalking skywalking -n monitoring --wait || true
helm install monitoring alertmanager-grafana -n monitoring --wait || true
helm install logging logstash-kibana -n logging --wait || true

# 5. 限流熔断
echo "  部署 Sentinel Dashboard..."
helm install sentinel sentinel-dashboard -n middleware --wait || true

cd "$HELM_DIR"

echo ""
echo "================================================"
echo " 🎉 基础服务部署完成！"
echo "================================================"
echo ""
echo "📋 查看部署状态："
echo "  kubectl get pods -n monitoring"
echo "  kubectl get pods -n logging"
echo "  kubectl get pods -n middleware"
echo ""
echo "📂 下一个步骤："
echo "  部署服务网格 (可选): ./deploy/scripts/deploy-istio.sh"
echo "  部署原子服务: ./deploy/scripts/deploy-atom-services-k8s.sh"
echo ""
echo "================================================"

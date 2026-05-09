#!/bin/bash

# Structure Cloud Pro - Docker Compose 开发环境完整一键启动
# 动态扫描目录执行启动

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 开发环境完整启动"
echo "================================================"
echo ""

cd "$PROJECT_ROOT"

# 检查 Docker 和 Docker Compose
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

# 1. 启动基础服务 - 动态扫描 basic 目录
echo ""
echo "▶️  第一步：启动基础服务..."
cd "$DOCKER_COMPOSE_DIR/basic"
BASIC_COUNT=0
for dir in */; do
    if [ -d "${dir}" ] && [ -f "${dir}scripts/init.sh" ]; then
        if [ -f "${dir}docker-compose.yml" ] || [ -f "${dir}docker-compose.yaml" ]; then
            COMPOSE_FILE=""
            if [ -f "${dir}docker-compose.yml" ]; then
                COMPOSE_FILE="${dir}docker-compose.yml"
            elif [ -f "${dir}docker-compose.yaml" ]; then
                COMPOSE_FILE="${dir}docker-compose.yaml"
            fi
            if [ -n "$COMPOSE_FILE" ]; then
                BASEDIR_NAME=${dir%/}
                echo "  [基础] 启动 ${BASEDIR_NAME}..."
                cd "$DOCKER_COMPOSE_DIR/basic/${dir}"
                sh ./scripts/init.sh
                $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" up -d --wait
                cd "$DOCKER_COMPOSE_DIR/basic"
                ((BASIC_COUNT++))
            fi
        fi
    fi
done
echo "  共启动 ${BASIC_COUNT} 个基础服务"
cd "$DOCKER_COMPOSE_DIR"

# 2. 等待 Nacos 完全启动
echo ""
echo "⏳ 等待 Nacos 完全启动（30秒）..."
sleep 30

# 3. 启动原子服务 - 动态扫描 atom 目录
echo ""
echo "▶️  第二步：启动原子服务..."
cd "$DOCKER_COMPOSE_DIR/atom"
ATOM_COUNT=0
for dir in */; do
    if [ -d "${dir}" ] && [ -f "${dir}scripts/init.sh" ]; then
        if [ -f "${dir}docker-compose.yml" ] || [ -f "${dir}docker-compose.yaml" ]; then
            COMPOSE_FILE=""
            if [ -f "${dir}docker-compose.yml" ]; then
                COMPOSE_FILE="${dir}docker-compose.yml"
            elif [ -f "${dir}docker-compose.yaml" ]; then
                COMPOSE_FILE="${dir}docker-compose.yaml"
            fi
            if [ -n "$COMPOSE_FILE" ]; then
                ATOMDIR_NAME=${dir%/}
                echo "  [原子] 启动 ${ATOMDIR_NAME}..."
                cd "$DOCKER_COMPOSE_DIR/atom/${dir}"
                sh ./scripts/init.sh
                $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" up -d --wait || true
                cd "$DOCKER_COMPOSE_DIR/atom"
                ((ATOM_COUNT++))
            fi
        fi
    fi
done
echo "  共启动 ${ATOM_COUNT} 个原子服务"
cd "$DOCKER_COMPOSE_DIR"

# 4. 启动应用系统 - 动态扫描 apps 目录
echo ""
echo "▶️  第三步：启动应用系统..."
cd "$DOCKER_COMPOSE_DIR/apps"
APP_COUNT=0
for dir in */; do
    if [ -d "${dir}" ] && [ -f "${dir}scripts/init.sh" ]; then
        if [ -f "${dir}docker-compose.yml" ] || [ -f "${dir}docker-compose.yaml" ]; then
            COMPOSE_FILE=""
            if [ -f "${dir}docker-compose.yml" ]; then
                COMPOSE_FILE="${dir}docker-compose.yml"
            elif [ -f "${dir}docker-compose.yaml" ]; then
                COMPOSE_FILE="${dir}docker-compose.yaml"
            fi
            if [ -n "$COMPOSE_FILE" ]; then
                APPDIR_NAME=${dir%/}
                echo "  [应用] 启动 ${APPDIR_NAME}..."
                cd "$DOCKER_COMPOSE_DIR/apps/${dir}"
                sh ./scripts/init.sh
                $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" up -d --wait || true
                cd "$DOCKER_COMPOSE_DIR/apps"
                ((APP_COUNT++))
            fi
        fi
    fi
done
echo "  共启动 ${APP_COUNT} 个应用系统"
cd "$DOCKER_COMPOSE_DIR"

echo ""
echo "================================================"
echo " 🎉🎊 恭喜！所有服务已启动！"
echo "================================================"
echo ""
echo "📊 启动统计："
echo "  基础服务: ${BASIC_COUNT} 个"
echo "  原子服务: ${ATOM_COUNT} 个"
echo "  应用系统: ${APP_COUNT} 个"
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
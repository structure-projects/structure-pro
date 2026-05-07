#!/bin/bash

# Structure Cloud Pro - 停止所有服务
# 动态扫描目录执行停止

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKER_COMPOSE_DIR="$PROJECT_ROOT/deploy/docker-compose"

echo "================================================"
echo " Structure Cloud Pro - 停止所有服务"
echo "================================================"
echo ""

cd "$DOCKER_COMPOSE_DIR"

# 检查 docker-compose 命令
if ! command -v docker-compose &> /dev/null; then
    if ! command -v docker compose &> /dev/null; then
        echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
        exit 1
    fi
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

# 1. 停止应用系统 - 动态扫描 apps 目录
echo "🟨 停止应用系统..."
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
                echo "  停止 ${APPDIR_NAME}..."
                cd "$DOCKER_COMPOSE_DIR/apps/${dir}"
                $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" down || true
                cd "$DOCKER_COMPOSE_DIR/apps"
                ((APP_COUNT++))
            fi
        fi
    fi
done
echo "  共停止 ${APP_COUNT} 个应用系统"
cd ..

# 2. 停止原子服务 - 动态扫描 atom 目录
echo ""
echo "🟨 停止原子服务..."
cd atom
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
                echo "  停止 ${ATOMDIR_NAME}..."
                cd "$DOCKER_COMPOSE_DIR/atom/${dir}"
                $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" down || true
                cd "$DOCKER_COMPOSE_DIR/atom"
                ((ATOM_COUNT++))
            fi
        fi
    fi
done
echo "  共停止 ${ATOM_COUNT} 个原子服务"
cd ..

# 3. 停止基础服务 - 动态扫描 basic 目录
echo ""
echo "🟨 停止基础服务..."
cd basic
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
                echo "  停止 ${BASEDIR_NAME}..."
                cd "$DOCKER_COMPOSE_DIR/basic/${dir}"
                $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" down || true
                cd "$DOCKER_COMPOSE_DIR/basic"
                ((BASIC_COUNT++))
            fi
        fi
    fi
done
echo "  共停止 ${BASIC_COUNT} 个基础服务"
cd ..

echo ""
echo "🧹 移除网络..."
docker network rm structure-cloud-work 2>/dev/null || true

echo ""
echo "================================================"
echo " 🛑 所有服务已停止！"
echo "================================================"
echo ""
echo "📊 停止统计："
echo "  基础服务: ${BASIC_COUNT} 个"
echo "  原子服务: ${ATOM_COUNT} 个"
echo "  应用系统: ${APP_COUNT} 个"
echo ""
echo "如需清理数据，运行: ./deploy/scripts/clean-all-data.sh"
echo ""
#!/bin/bash

set -e

SWARM_NETWORK="structure-cloud-work"

echo "=============================================="
echo "    Structure Cloud Docker Swarm 清理脚本"
echo "=============================================="
echo ""

remove_services() {
    echo "==> 移除应用系统..."
    docker stack rm content-manager-system 2>/dev/null || true
    docker stack rm manager-system 2>/dev/null || true

    echo "==> 移除原子服务..."
    docker stack rm user-center 2>/dev/null || true
    docker stack rm oauth-center 2>/dev/null || true
    docker stack rm content-center 2>/dev/null || true
    docker stack rm job-center 2>/dev/null || true
    docker stack rm admin-center 2>/dev/null || true

    echo "==> 移除基础服务..."
    docker stack rm prometheus 2>/dev/null || true
    docker stack rm elasticsearch 2>/dev/null || true
    docker stack rm redis 2>/dev/null || true
    docker stack rm mysql 2>/dev/null || true
    docker stack rm kafka 2>/dev/null || true
    docker stack rm rabbitmq 2>/dev/null || true
    docker stack rm nacos 2>/dev/null || true
    docker stack rm skywalking 2>/dev/null || true
    docker stack rm alertmanager-grafana 2>/dev/null || true
    docker stack rm logstash-kibana 2>/dev/null || true
    docker stack rm sentinel 2>/dev/null || true
    docker stack rm kong-gateway 2>/dev/null || true

    echo "==> 等待服务完全移除..."
    sleep 10
}

cleanup_network() {
    echo "==> 清理 Overlay 网络..."
    if docker network ls | grep -q "${SWARM_NETWORK}"; then
        docker network rm "${SWARM_NETWORK}" 2>/dev/null || true
    fi
}

cleanup_volumes() {
    echo "==> 清理未使用的卷..."
    docker volume prune -f 2>/dev/null || true
}

cleanup_images() {
    echo "==> 清理未使用的镜像..."
    docker image prune -af 2>/dev/null || true
}

show_status() {
    echo ""
    echo "=============================================="
    echo "         Docker Swarm 集群清理完成"
    echo "=============================================="
    echo ""
    echo "残留检查:"
    docker service ls 2>/dev/null || echo "  - 无 Swarm 服务"
    docker stack ls 2>/dev/null || echo "  - 无 Swarm 栈"
    echo ""
}

main() {
    remove_services
    cleanup_network
    cleanup_volumes
    cleanup_images
    show_status
}

main "$@"
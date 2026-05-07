#!/bin/bash

set -e

SWARM_NETWORK="structure-cloud-work"
COMPOSE_DIR="deploy/docker-compose"

init_swarm() {
    echo "==> 检查 Docker Swarm 集群状态..."
    if [ -z "$(docker info 2>/dev/null | grep Swarm)" ]; then
        echo "==> 初始化 Docker Swarm 集群..."
        docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')
    else
        echo "==> 当前节点已在 Swarm 集群中"
    fi
}

create_overlay_network() {
    echo "==> 创建 Overlay 网络: ${SWARM_NETWORK}..."
    if docker network ls | grep -q "${SWARM_NETWORK}"; then
        echo "==> 网络 ${SWARM_NETWORK} 已存在"
    else
        docker network create --driver overlay --attachable "${SWARM_NETWORK}"
        echo "==> 网络 ${SWARM_NETWORK} 创建成功"
    fi
}

deploy_basic_services() {
    echo "==> 开始部署基础服务..."
    cd "${COMPOSE_DIR}"

    echo "==> [1/12] 部署 Prometheus..."
    cd basic/prometheus
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml prometheus
    cd ../..

    echo "==> [2/12] 部署 Elasticsearch..."
    cd basic/elasticsearch
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml elasticsearch
    cd ../..

    echo "==> [3/12] 部署 Redis..."
    cd basic/redis
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml redis
    cd ../..

    echo "==> [4/12] 部署 MySQL..."
    cd basic/mysql
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml mysql
    cd ../..

    echo "==> [5/12] 部署 Kafka..."
    cd basic/kafka
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml kafka
    cd ../..

    echo "==> [6/12] 部署 RabbitMQ..."
    cd basic/rabbitmq
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml rabbitmq
    cd ../..

    echo "==> [7/12] 部署 Nacos..."
    cd basic/nacos
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml nacos
    cd ../..

    echo "==> [8/12] 部署 SkyWalking..."
    cd basic/skywalking
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml skywalking
    cd ../..

    echo "==> [9/12] 部署 AlertManager & Grafana..."
    cd basic/alertmanager-grafana
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml alertmanager-grafana
    cd ../..

    echo "==> [10/12] 部署 Logstash & Kibana..."
    cd basic/logstash-kibana
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml logstash-kibana
    cd ../..

    echo "==> [11/12] 部署 Sentinel Dashboard..."
    cd basic/sentinel-dashboard
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml sentinel
    cd ../..

    echo "==> [12/12] 部署 Kong Gateway..."
    cd basic/kong-gateway
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml kong-gateway
    cd ../..

    cd - > /dev/null
    echo "==> 基础服务部署完成"
}

deploy_atom_services() {
    echo "==> 开始部署原子服务..."
    cd "${COMPOSE_DIR}"

    echo "==> [1/5] 部署用户中心 - User Center..."
    cd atom/user-center
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml user-center
    cd ../..

    echo "==> [2/5] 部署认证中心 - OAuth Center..."
    cd atom/oauth-center
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml oauth-center
    cd ../..

    echo "==> [3/5] 部署内容中心 - Content Center..."
    cd atom/content-center
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml content-center
    cd ../..

    echo "==> [4/5] 部署任务中心 - Job Center..."
    cd atom/job-center
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml job-center
    cd ../..

    echo "==> [5/5] 部署管理后台 - Admin Center..."
    cd atom/admin-center
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml admin-center
    cd ../..

    cd - > /dev/null
    echo "==> 原子服务部署完成"
}

deploy_app_services() {
    echo "==> 开始部署应用系统..."
    cd "${COMPOSE_DIR}"

    echo "==> [1/2] 部署内容管理系统 - Content Manager System..."
    cd apps/content-manager-system
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml content-manager-system
    cd ../..

    echo "==> [2/2] 部署管理系统 - Manager System..."
    cd apps/manager-system
    sh ./scripts/init.sh
    docker stack deploy -c service.yaml manager-system
    cd ../..

    cd - > /dev/null
    echo "==> 应用系统部署完成"
}

check_services() {
    echo "==> 检查服务状态..."
    docker stack ps "${SWARM_NETWORK}" 2>/dev/null || echo "使用 docker ps 检查运行中的容器"
    docker service ls 2>/dev/null || echo "Swarm 服务列表不可用"
}

show_endpoints() {
    echo ""
    echo "=============================================="
    echo "         Docker Swarm 集群部署完成"
    echo "=============================================="
    echo ""
    echo "访问入口:"
    echo "  - Nacos 控制台:     http://localhost:8848/nacos (nacos/nacos)"
    echo "  - SkyWalking UI:    http://localhost:8080"
    echo "  - Grafana:          http://localhost:3000 (admin/admin123)"
    echo "  - Kibana:           http://localhost:5601"
    echo "  - Sentinel Dashboard: http://localhost:8858 (sentinel/sentinel)"
    echo "  - Kong Admin:       http://localhost:8001"
    echo ""
    echo " Swarm 管理命令:"
    echo "  - 查看服务列表:     docker service ls"
    echo "  - 查看服务状态:     docker stack ps ${SWARM_NETWORK}"
    echo "  - 查看日志:         docker service logs <service_name>"
    echo "  - 扩展服务:         docker service scale <service_name>=3"
    echo "  - 移除服务:         docker stack rm <stack_name>"
    echo ""
}

main() {
    echo "=============================================="
    echo "    Structure Cloud Docker Swarm 部署脚本"
    echo "=============================================="
    echo ""

    init_swarm
    create_overlay_network
    deploy_basic_services
    deploy_atom_services
    deploy_app_services
    check_services
    show_endpoints
}

main "$@"
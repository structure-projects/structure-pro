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
    cd "${COMPOSE_DIR}/basic"

    echo "==> [1/10] 部署存储服务 - Prometheus..."
    docker stack deploy -c prometheus/docker-compose.yml prometheus 2>/dev/null || docker-compose -f prometheus/docker-compose.yml up -d

    echo "==> [2/10] 部署存储服务 - Elasticsearch..."
    docker stack deploy -c elasticsearch/docker-compose.yml elasticsearch 2>/dev/null || docker-compose -f elasticsearch/docker-compose.yml up -d

    echo "==> [3/10] 部署存储服务 - Redis..."
    docker stack deploy -c redis/docker-compose.yaml redis 2>/dev/null || docker-compose -f redis/docker-compose.yaml up -d

    echo "==> [4/10] 部署存储服务 - MySQL..."
    docker stack deploy -c mysql/docker-compose.yaml mysql 2>/dev/null || docker-compose -f mysql/docker-compose.yaml up -d

    echo "==> [5/10] 部署消息队列 - Kafka..."
    docker stack deploy -c kafka/docker-compose.yml kafka 2>/dev/null || docker-compose -f kafka/docker-compose.yml up -d

    echo "==> [6/10] 部署消息队列 - RabbitMQ..."
    docker stack deploy -c rabbitmq/docker-compose.yml rabbitmq 2>/dev/null || docker-compose -f rabbitmq/docker-compose.yml up -d

    echo "==> [7/10] 部署注册与配置中心 - Nacos..."
    docker stack deploy -c nacos/docker-compose.yaml nacos 2>/dev/null || docker-compose -f nacos/docker-compose.yaml up -d

    echo "==> [8/10] 部署可观测性服务 - SkyWalking..."
    docker stack deploy -c skywalking/docker-compose.yml skywalking 2>/dev/null || docker-compose -f skywalking/docker-compose.yml up -d

    echo "==> [9/10] 部署可观测性服务 - AlertManager & Grafana..."
    docker stack deploy -c alertmanager-grafana/docker-compose.yml alertmanager-grafana 2>/dev/null || docker-compose -f alertmanager-grafana/docker-compose.yml up -d

    echo "==> [10/10] 部署可观测性服务 - Logstash & Kibana..."
    docker stack deploy -c logstash-kibana/docker-compose.yml logstash-kibana 2>/dev/null || docker-compose -f logstash-kibana/docker-compose.yml up -d

    echo "==> [附加] 部署限流熔断控制台 - Sentinel Dashboard..."
    docker stack deploy -c sentinel-dashboard/docker-compose.yml sentinel 2>/dev/null || docker-compose -f sentinel-dashboard/docker-compose.yml up -d

    echo "==> [附加] 部署 API 网关 - Kong Gateway..."
    docker stack deploy -c kong-gateway/docker-compose.yaml kong-gateway 2>/dev/null || docker-compose -f kong-gateway/docker-compose.yaml up -d

    cd - > /dev/null
    echo "==> 基础服务部署完成"
}

deploy_atom_services() {
    echo "==> 开始部署原子服务..."
    cd "${COMPOSE_DIR}/atom"

    echo "==> [1/5] 部署用户中心 - User Center..."
    docker stack deploy -c user-center/docker-compose.yaml user-center 2>/dev/null || docker-compose -f user-center/docker-compose.yaml up -d

    echo "==> [2/5] 部署认证中心 - OAuth Center..."
    docker stack deploy -c oauth-center/docker-compose.yaml oauth-center 2>/dev/null || docker-compose -f oauth-center/docker-compose.yaml up -d

    echo "==> [3/5] 部署内容中心 - Content Center..."
    docker stack deploy -c content-center/docker-compose.yaml content-center 2>/dev/null || docker-compose -f content-center/docker-compose.yaml up -d

    echo "==> [4/5] 部署任务中心 - Job Center..."
    docker stack deploy -c job-center/docker-compose.yaml job-center 2>/dev/null || docker-compose -f job-center/docker-compose.yaml up -d

    echo "==> [5/5] 部署管理后台 - Admin Center..."
    docker stack deploy -c admin-center/docker-compose.yaml admin-center 2>/dev/null || docker-compose -f admin-center/docker-compose.yaml up -d

    cd - > /dev/null
    echo "==> 原子服务部署完成"
}

deploy_app_services() {
    echo "==> 开始部署应用系统..."
    cd "${COMPOSE_DIR}/apps"

    echo "==> [1/2] 部署内容管理系统 - Content Manager System..."
    docker stack deploy -c content-manager-system/docker-compose.yaml content-manager-system 2>/dev/null || docker-compose -f content-manager-system/docker-compose.yaml up -d

    echo "==> [2/2] 部署管理系统 - Manager System..."
    docker stack deploy -c manager-system/docker-compose.yaml manager-system 2>/dev/null || docker-compose -f manager-system/docker-compose.yaml up -d

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
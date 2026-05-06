#!/bin/bash
# 快速启动 Consul 和 Nomad 脚本
# 使用方法: ./quick-start.sh [server|client]

set -e

NOMAD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$NOMAD_DIR"

case "${1:-server}" in
    server)
        echo "=== 启动 Consul Server ==="
        consul agent -config-file=config/consul-server.hcl -daemon
        sleep 3

        echo "=== 启动 Nomad Server ==="
        nomad agent -config=config/nomad-server.hcl -daemon
        sleep 3

        echo "=== 检查集群状态 ==="
        consul members
        nomad server members

        echo "==============================================="
        echo "✅ Consul 和 Nomad Server 启动完成！"
        echo "📊 Consul UI: http://localhost:8500"
        echo "📊 Nomad UI: http://localhost:4646"
        echo "==============================================="
        ;;

    client)
        echo "=== 启动 Consul Client ==="
        consul agent -config-file=config/consul-client.hcl -daemon
        sleep 3

        echo "=== 启动 Nomad Client ==="
        nomad agent -config=config/nomad-client.hcl -daemon
        sleep 3

        echo "==============================================="
        echo "✅ Consul 和 Nomad Client 启动完成！"
        echo "==============================================="
        ;;

    *)
        echo "使用方法: $0 [server|client]"
        echo "  server - 在 Server 节点上运行"
        echo "  client - 在 Client 节点上运行"
        exit 1
        ;;
esac

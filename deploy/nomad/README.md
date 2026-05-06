# Nomad 编排指南

## 概述

本指南帮助你在 structure-cloud-pro 项目中使用 HashiCorp Nomad 进行工作负载编排。所有 docker-compose 配置已转换为 Nomad job 文件。

## 项目结构

```
deploy/nomad/
├── config/
│   ├── nomad-server.hcl              # Nomad Server 配置
│   ├── nomad-client.hcl              # Nomad Client 配置
│   ├── consul-server.hcl             # Consul Server 配置
│   └── consul-client.hcl             # Consul Client 配置
├── jobs/
│   ├── basic/                        # 基础服务
│   │   ├── mysql.nomad
│   │   ├── postgresql.nomad
│   │   ├── redis.nomad
│   │   ├── mongodb.nomad
│   │   ├── kafka.nomad
│   │   ├── rabbitmq.nomad
│   │   ├── nacos.nomad
│   │   ├── minio.nomad
│   │   ├── elasticsearch.nomad
│   │   ├── prometheus.nomad
│   │   ├── grafana.nomad
│   │   ├── ...                      # 更多基础服务
│   ├── atom/                         # 微服务原子模块
│   │   ├── admin-center.nomad
│   │   ├── content-center.nomad
│   │   ├── oauth-center.nomad
│   │   ├── user-center.nomad
│   │   └── job-center.nomad
│   ├── apps/                         # 应用服务
│   │   ├── content-manager-system.nomad
│   │   └── manager-system.nomad
│   ├── view/                         # 前端服务
│   │   ├── web-pc-cms-ui.nomad
│   │   └── web-pc-manager-ui.nomad
│   ├── dev-ops-tools/                # DevOps 工具
│   │   ├── it-tools.nomad
│   │   ├── netclient.nomad
│   │   └── netgateway.nomad
│   └── template/
│       └── service-template.nomad
├── generate_nomad_jobs.py           # Job 生成脚本
├── convert_compose_to_nomad.py      # Docker Compose 转换脚本
└── README.md
```

## 快速开始

### 1. 安装 Nomad

```bash
# 下载 Nomad
curl -fsSL https://releases.hashicorp.com/nomad/1.7.0/nomad_1.7.0_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo mv nomad /usr/local/bin/

# 验证安装
nomad version
```

### 2. 启动 Nomad Server

```bash
# 在 3 个 manager 节点上运行
nomad agent -config=config/nomad-server.hcl
```

### 3. 启动 Nomad Client

```bash
# 在所有 worker 节点上运行
nomad agent -config=config/nomad-client.hcl
```

### 4. 提交 Job

```bash
# 提交单个服务
nomad job run jobs/basic/mysql.nomad

# 提交多个服务
nomad job run jobs/atom/admin-center.nomad
nomad job run jobs/atom/user-center.nomad

# 查看 job 状态
nomad job status

# 查看特定 job
nomad job status mysql

# 查看 allocation
nomad job allocations mysql
```

## 服务列表

### 基础服务 (Basic Services)
- 数据库：MySQL, PostgreSQL, MongoDB, MariaDB, MSSQL
- 缓存：Redis, Memcached
- 消息队列：Kafka, RabbitMQ, RocketMQ
- 服务注册：Nacos, Consul
- 对象存储：MinIO
- 搜索引擎：Elasticsearch
- 监控：Prometheus, Grafana, Alertmanager, SkyWalking
- 时序数据库：InfluxDB, ClickHouse
- MQTT：EMQX
- 图数据库：Neo4j
- 目录服务：OpenLDAP
- 分布式事务：Seata
- 流量控制：Sentinel
- API 网关：Kong

### 原子微服务 (Atom Services)
- admin-center: 管理中心
- content-center: 内容中心
- oauth-center: 认证中心
- user-center: 用户中心
- job-center: 任务中心

### 应用服务 (Apps)
- content-manager-system: 内容管理系统
- manager-system: 管理系统

### 前端服务 (View)
- web-pc-cms-ui: CMS 管理端前端
- web-pc-manager-ui: 管理系统前端

## Docker Compose 到 Nomad 的转换规则

### 基本映射关系

| Docker Compose | Nomad HCL |
|----------------|-----------|
| `services[].image` | `task.config.image` |
| `services[].ports` | `network.port` |
| `services[].networks` | `network` |
| `services[].deploy.resources.limits.memory` | `resources.memory` |
| `services[].deploy.resources.limits.cpus` | `resources.cpu` |
| `services[].restart` | `restart` |
| `services[].environment` | `env` |
| `services[].volumes` | `volume` |
| `services[].labels` | `service.tags` |

### 示例转换

#### Docker Compose

```yaml
version: '3.8'
services:
  mysql:
    container_name: mysql
    image: mysql:8.0.25
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    restart: always
```

#### Nomad Job

```hcl
job "mysql" {
  datacenters = ["dc1"]
  type        = "service"

  group "mysql" {
    count = 1

    network {
      port "mysql" {
        static = 3306
        to     = 3306
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8.0.25"
        ports = ["mysql"]
      }

      env {
        "MYSQL_ROOT_PASSWORD" = "123456"
        "CREATED_BY" = "Nomad"
      }

      resources {
        cpu    = 2000
        memory = 4096
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "mysql"
        tags = ["mysql", "database"]
        port = "mysql"
        check {
          name     = "tcp"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
```

## 常用命令

```bash
# Job 管理
nomad job run <jobfile.nomad>
nomad job status <job_name>
nomad job stop <job_name>
nomad job restart <job_name>
nomad job scale <job_name> <count>

# 节点管理
nomad node status
nomad node drain <node_id>

# 查看日志
nomad alloc logs <allocation_id>
nomad alloc logs -f <allocation_id>

# 系统信息
nomad server members
nomad agent-info

# UI 访问
# 默认访问 http://localhost:4646/ui
```

## 与 Consul 集成

### 集成优势

Nomad 天然支持与 Consul 集成，实现以下功能：

1. **服务发现**：服务自动注册到 Consul
2. **健康检查**：Consul 自动检查服务健康状态
3. **DNS 查询**：通过 Consul DNS 进行服务发现
4. **负载均衡**：Consul 提供简单的负载均衡
5. **KV 存储**：使用 Consul KV 存储配置

### 配置说明

在 Nomad 配置文件中已包含 Consul 集成配置：

```hcl
consul {
  address = "127.0.0.1:8500"
}
```

### 使用方式

#### 1. 服务自动注册

所有 Nomad job 中的 `service` 块会自动注册到 Consul：

```hcl
service {
  name = "mysql"
  tags = ["mysql", "database"]
  port = "mysql"
  check {
    name     = "tcp"
    type     = "tcp"
    interval = "10s"
    timeout  = "2s"
  }
}
```

#### 2. 通过 Consul DNS 发现服务

```bash
# 查询服务
dig @127.0.0.1 -p 8600 mysql.service.consul SRV

# 在应用中使用服务名连接
mysql.service.consul:3306
```

#### 3. 访问 Consul UI

打开浏览器访问：`http://<server-ip>:8500`

在 UI 中可以：
- 查看所有注册的服务
- 检查服务健康状态
- 查看节点信息
- 管理 KV 存储

### 手动部署 Consul（可选）

如果不想直接在主机上运行 Consul，可以通过 Nomad 部署：

```bash
nomad job run jobs/basic/consul.nomad
```

注意：不推荐在生产环境中用 Nomad 运行 Consul server，建议直接在主机上部署 Consul 以保证高可用性。

## 高可用部署

建议使用 3 或 5 个 Server 节点：

```bash
# 初始化集群
nomad operator raft list-peers
```

## 部署顺序建议

1. 先部署基础服务：数据库、缓存、消息队列
2. 再部署中间件：服务注册、网关、监控
3. 最后部署应用服务和前端

## 注意事项

1. **网络配置**：确保所有节点的防火墙开放 4646-4648 端口
2. **Docker 权限**：将用户加入 docker 组或使用 sudo
3. **资源限制**：Nomad 会强制执行 resources 限制
4. **持久化存储**：使用 host 类型的 volume 挂载本地目录
5. **环境变量**：需要根据实际情况修改 job 文件中的 env 配置
6. **镜像拉取**：确保节点能够访问到所需的 Docker 镜像仓库

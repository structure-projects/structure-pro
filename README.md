# structure-cloud-pro

## 项目简介

structure-cloud-pro 是一个基于云原生的微服务架构脚手架方案，提供完整的容器化部署和管理方案，涵盖从开发、构建、部署到运维的全流程最佳实践。

## 技术架构

### 整体架构图

```
┌───────────────────────────────────────────────────────────────────────┐
│                          接入层 (Ingress)                              │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐            │
│  │   Kong      │  │   Istio     │  │  HTTPS  │            │
│  │   Gateway   │  │   Gateway    │  │  443/80  │            │
│  └───────────────┘  └───────────────┘  └───────────────┘            │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                          服务网格层 (Service Mesh)                    │
│                       Istio 流量管理 / mTLS 安全                        │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                          网关层 (Gateway)                             │
│                  ┌───────────────────────────────┐                   │
│                  │  structure-cloud-gateway      │                   │
│                  │  - 路由转发                  │                   │
│                  │  - 限流熔断                  │                   │
│                  │  - 认证鉴权                  │                   │
│                  └───────────────────────────────┘                   │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                          业务服务层 (Business Services)                │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐     │
│ │ user-center│ │oauth-center │ │content-center│ │ job-center │     │
│ │   用户中心  │ │   认证授权  │ │   内容中心  │ │ 任务调度    │     │
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘     │
│ ┌─────────────┐ ┌───────────────────────────────────────────────┐   │
│ │admin-center │ │ content-manager-system / manager-system       │   │
│ │   管理中心  │ │            应用系统聚合层                      │   │
│ └─────────────┘ └───────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                          基础设施层 (Infrastructure)                  │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  注册与配置     │  Nacos: 服务注册 / 配置中心              │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  消息队列       │  Kafka / RabbitMQ                         │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  缓存           │  Redis: 分布式缓存 / Session共享            │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  数据存储       │  MySQL / PostgreSQL / MongoDB / MinIO      │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  分布式事务     │  Seata: 分布式事务协调                    │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  限流熔断       │  Sentinel: 流量控制 / 熔断降级             │ │
│ └───────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                          可观测性层 (Observability)                   │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐     │
│ │  Prometheus │ │  Grafana   │ │  AlertManager │ │  Kibana   │     │
│ │  监控指标   │ │  可视化    │ │  告警通知     │ │  日志查询  │     │
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘     │
│ ┌─────────────┐ ┌─────────────┐                                      │
│ │  SkyWalking │ │  Logstash  │                                      │
│ │  链路追踪   │ │  日志收集  │                                      │
│ └─────────────┘ └─────────────┘                                      │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                          基础设施 (Infrastructure)                     │
│               Docker / Kubernetes / Helm                              │
└───────────────────────────────────────────────────────────────────────┘
```

### 技术栈详情

#### 核心技术

| 组件 | 技术选型 | 版本 | 功能 |
|------|----------|------|------|
| **开发语言** | Java | 8 | 业务开发 |
| **微服务框架** | Spring Cloud | - | 微服务架构 |
| **服务注册与发现** | Nacos | 2.2.3 | 服务注册发现 |
| **配置中心** | Nacos | 2.2.3 | 配置管理 |
| **API网关** | Kong Gateway / Istio Gateway | latest | 入口流量管理 |
| **服务网格** | Istio | 1.20.0 | 服务网格管理 |
| **分布式事务** | Seata | latest | 分布式事务协调 |
| **限流熔断** | Sentinel | 1.8.8 | 流量控制 / 熔断降级 |
| **分布式追踪** | SkyWalking | 9.5.0 | 链路追踪 |

#### 消息队列与缓存

| 组件 | 技术选型 | 版本 | 功能 |
|------|----------|------|------|
| **消息队列** | Kafka | latest | 高性能消息中间件 |
| **消息队列** | RabbitMQ | 3.x | 企业级消息队列 |
| **分布式缓存** | Redis | latest | 分布式缓存 / Session共享 |
| **时间序列数据库** | InfluxDB | latest | 指标存储 |

#### 数据存储

| 组件 | 技术选型 | 版本 | 功能 |
|------|----------|------|------|
| **关系型数据库** | MySQL | latest | 业务数据存储 |
| **关系型数据库** | PostgreSQL | latest | 业务数据存储 |
| **文档数据库** | MongoDB | latest | 文档存储 |
| **图数据库** | Neo4j | latest | 图数据存储 |
| **分布式搜索引擎** | Elasticsearch | 8.16.0 | 搜索引擎 |
| **列式存储** | ClickHouse | latest | OLAP 分析 |
| **对象存储** | MinIO | latest | 对象存储服务 |

#### 可观测性

| 组件 | 技术选型 | 版本 | 功能 |
|------|----------|------|------|
| **指标监控** | Prometheus | 2.55.1 | 指标采集与存储 |
| **监控可视化** | Grafana | 10.4.0 | 监控面板 |
| **告警通知** | AlertManager | 0.27.0 | 告警管理 |
| **链路追踪** | SkyWalking | 9.5.0 | 分布式链路追踪 |
| **日志收集** | Logstash | 8.16.0 | 日志采集与处理 |
| **日志查询** | Kibana | 8.16.0 | 日志可视化查询 |

#### 容器化与编排

| 组件 | 技术选型 | 版本 | 功能 |
|------|----------|------|------|
| **容器运行时** | Docker | 20.10+ | 容器运行 |
| **容器编排** | Docker Swarm / Kubernetes | 1.20+ | 容器编排管理 |
| **包管理** | Helm | 3.0+ | Kubernetes 包管理 |
| **消息协议** | MQTT via EMQX | latest | IoT 消息协议 |

### 服务网络拓扑

```
User Browser
     │
     ▼
┌──────────────────────────────────────────────────┐
│              Ingress Controller                  │
│           (Nginx / Kong / Istio Gateway)         │
└──────────────────────────────────────────────────┘
     │
     ▼
┌──────────────────────────────────────────────────┐
│           Istio Service Mesh (mTLS)             │
└──────────────────────────────────────────────────┘
     │
     ├─────────────────────────────────────────────┐
     │                                             │
     ▼                                             ▼
┌──────────────────┐              ┌──────────────────┐
│   Gateway  │              │  Internal Services │
│  Services   │              │  (User, Content, │
└──────────────────┘              │    OAuth, etc)  │
     │                             └──────────────────┘
     ▼
┌──────────────────────────────────────────────────┐
│              业务服务集群                          │
└──────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────┐
│              数据/中间件层                        │
│  MySQL  │  PostgreSQL  │  Redis  │  Kafka  │  ES  │
└──────────────────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────┐
│              可观测性层                            │
│  Prometheus  │  Grafana  │  SkyWalking  │  ELK │
└──────────────────────────────────────────────────┘
```

## 项目结构

### 目录结构

```
structure-cloud-pro/
├── structure-cloud-gateway/       # 网关服务
├── structure-monitoring-center/    # 监控中心
├── deploy/                        # 部署配置
│   ├── docker-compose/            # Docker Compose 部署
│   │   ├── basic/                # 基础服务
│   │   │   ├── elasticsearch/
│   │   │   ├── kafka/
│   │   │   ├── kibana/
│   │   │   ├── kong-gateway/
│   │   │   ├── logstash-kibana/
│   │   │   ├── nacos/
│   │   │   ├── prometheus/
│   │   │   ├── rabbitmq/
│   │   │   ├── redis/
│   │   │   ├── sentinel-dashboard/
│   │   │   ├── skywalking/
│   │   │   ├── alertmanager-grafana/
│   │   │   └── istio/
│   │   ├── atom/                 # 原子服务
│   │   │   ├── admin-center/
│   │   │   ├── content-center/
│   │   │   ├── job-center/
│   │   │   ├── oauth-center/
│   │   │   └── user-center/
│   │   ├── apps/                 # 应用系统
│   │   │   ├── content-manager-system/
│   │   │   └── manager-system/
│   │   └── view/                 # 前端应用
│   │       ├── web-pc-cms-ui/
│   │       └── web-pc-manager-ui/
│   ├── helm/                     # Helm Charts 部署
│   │   └── basic/                # 基础服务 Helm
│   └── serverless-fc/            # Serverless 函数计算部署
├── scripts/                      # 部署脚本
└── pom.xml                       # Maven 父 POM
```

### 服务模块

#### 原子服务 (Atom Services)

| 服务名称 | 功能描述 | 端口 |
|----------|----------|------|
| **user-center** | 用户中心服务 | - |
| **oauth-center** | 认证授权中心 | - |
| **content-center** | 内容中心服务 | - |
| **job-center** | 任务调度中心 | - |
| **admin-center** | 管理中心服务 | - |

#### 应用系统 (Application Systems)

| 系统名称 | 功能描述 |
|----------|----------|
| **content-manager-system** | 内容管理系统 |
| **manager-system** | 管理系统 |

#### 前端应用 (Frontend)

| 应用名称 | 功能描述 |
|----------|----------|
| **web-pc-cms-ui** | 内容管理系统 PC 端 |
| **web-pc-manager-ui** | 管理系统 PC 端 |

#### 基础设施服务

| 服务名称 | 功能描述 | 端口 |
|----------|----------|------|
| **Nacos** | 服务注册与发现 / 配置中心 | 8848, 9848 |
| **Kong Gateway** | API 网关 | 8000, 8443, 8001 |
| **Istio** | 服务网格 | 80, 443, 15012, 15014 |
| **Sentinel Dashboard** | 限流熔断控制台 | 8858, 8719 |
| **SkyWalking OAP** | 链路追踪 OAP 服务 | 11800, 12800 |
| **SkyWalking UI** | 链路追踪可视化 | 8080 |
| **Prometheus** | 指标监控 | 9090 |
| **AlertManager** | 告警管理 | 9093, 9094 |
| **Grafana** | 监控可视化 | 3000 |
| **Elasticsearch** | 搜索引擎 / 日志存储 | 9200 |
| **Logstash** | 日志收集与处理 | 5044, 5000, 9600 |
| **Kibana** | 日志查询可视化 | 5601 |

## 快速开始

### 环境要求

- **Docker**: 20.10+
- **Docker Compose**: 1.29+
- **Kubernetes**: 1.20+ (可选)
- **Helm**: 3.0+ (可选)

### Docker Compose 部署

#### 1. 准备网络与环境

```bash
# 创建网络
docker network create structure-cloud-work --driver overlay

# 进入项目根目录
cd deploy/docker-compose
```

#### 2. 启动基础服务

```bash
cd basic

# 1. 启动存储服务
docker-compose -f prometheus/docker-compose.yml up -d
docker-compose -f elasticsearch/docker-compose.yml up -d
docker-compose -f redis/docker-compose.yml up -d
docker-compose -f mysql/docker-compose.yml up -d

# 2. 启动消息队列
docker-compose -f kafka/docker-compose.yml up -d
docker-compose -f rabbitmq/docker-compose.yml up -d

# 3. 启动注册与配置中心
docker-compose -f nacos/docker-compose.yml up -d

# 4. 启动可观测性服务
docker-compose -f skywalking/docker-compose.yml up -d
docker-compose -f alertmanager-grafana/docker-compose.yml up -d
docker-compose -f logstash-kibana/docker-compose.yml up -d

# 5. 启动限流熔断控制台
docker-compose -f sentinel-dashboard/docker-compose.yml up -d

# 6. 启动 API 网关
docker-compose -f kong-gateway/docker-compose.yml up -d
```

#### 3. 启动原子服务

```bash
cd ../atom

docker-compose -f user-center/docker-compose.yaml up -d
docker-compose -f oauth-center/docker-compose.yaml up -d
docker-compose -f content-center/docker-compose.yaml up -d
docker-compose -f job-center/docker-compose.yaml up -d
docker-compose -f admin-center/docker-compose.yaml up -d
```

#### 4. 启动应用系统

```bash
cd ../apps

docker-compose -f content-manager-system/docker-compose.yaml up -d
docker-compose -f manager-system/docker-compose.yaml up -d
```

#### 5. 验证部署

- **Nacos 控制台**: http://localhost:8848/nacos (nacos/nacos)
- **SkyWalking UI**: http://localhost:8080
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Kibana**: http://localhost:5601
- **Sentinel Dashboard**: http://localhost:8858 (sentinel/sentinel)
- **Kong Admin**: http://localhost:8001

### Docker Swarm 集群部署

#### 1. 准备网络与环境

```bash
# 进入项目根目录
cd deploy/docker-compose

# 初始化 Docker Swarm（如果尚未初始化）
docker swarm init --advertise-addr <YOUR_IP>

# 创建 Overlay 网络
docker network create --driver overlay --attachable structure-cloud-work
```

#### 2. 部署基础服务

```bash
cd basic

# 使用 docker stack deploy 部署到 Swarm 集群
docker stack deploy -c prometheus/docker-compose.yml prometheus
docker stack deploy -c elasticsearch/docker-compose.yml elasticsearch
docker stack deploy -c redis/docker-compose.yaml redis
docker stack deploy -c mysql/docker-compose.yaml mysql
docker stack deploy -c kafka/docker-compose.yml kafka
docker stack deploy -c rabbitmq/docker-compose.yml rabbitmq
docker stack deploy -c nacos/docker-compose.yaml nacos
docker stack deploy -c skywalking/docker-compose.yml skywalking
docker stack deploy -c alertmanager-grafana/docker-compose.yml alertmanager-grafana
docker stack deploy -c logstash-kibana/docker-compose.yml logstash-kibana
docker stack deploy -c sentinel-dashboard/docker-compose.yml sentinel
docker stack deploy -c kong-gateway/docker-compose.yaml kong-gateway
```

#### 3. 部署原子服务

```bash
cd ../atom

docker stack deploy -c user-center/docker-compose.yaml user-center
docker stack deploy -c oauth-center/docker-compose.yaml oauth-center
docker stack deploy -c content-center/docker-compose.yaml content-center
docker stack deploy -c job-center/docker-compose.yaml job-center
docker stack deploy -c admin-center/docker-compose.yaml admin-center
```

#### 4. 部署应用系统

```bash
cd ../apps

docker stack deploy -c content-manager-system/docker-compose.yaml content-manager-system
docker stack deploy -c manager-system/docker-compose.yaml manager-system
```

#### 5. Swarm 集群管理命令

```bash
# 查看所有服务
docker service ls

# 查看服务状态
docker service ps <service_name>

# 查看服务日志
docker service logs <service_name>

# 扩展服务副本数
docker service scale <service_name>=3

# 移除服务
docker stack rm <stack_name>

# 移除整个集群
docker stack rm structure-cloud-work
```

#### 6. 验证部署

访问入口与 Docker Compose 部署相同：
- **Nacos 控制台**: http://localhost:8848/nacos (nacos/nacos)
- **SkyWalking UI**: http://localhost:8080
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Kibana**: http://localhost:5601
- **Sentinel Dashboard**: http://localhost:8858 (sentinel/sentinel)
- **Kong Admin**: http://localhost:8001

#### 7. 清理 Swarm 集群

```bash
# 进入部署目录
cd deploy/docker-compose

# 按顺序移除应用系统
docker stack rm content-manager-system
docker stack rm manager-system

# 移除原子服务
docker stack rm user-center
docker stack rm oauth-center
docker stack rm content-center
docker stack rm job-center
docker stack rm admin-center

# 移除基础服务
docker stack rm prometheus
docker stack rm elasticsearch
docker stack rm redis
docker stack rm mysql
docker stack rm kafka
docker stack rm rabbitmq
docker stack rm nacos
docker stack rm skywalking
docker stack rm alertmanager-grafana
docker stack rm logstash-kibana
docker stack rm sentinel
docker stack rm kong-gateway

# 等待服务移除完成后清理网络
sleep 10
docker network rm structure-cloud-work
```

## 🚀 快速启动脚本汇总

为了方便不同场景使用，项目提供了多种环境的快速启动脚本：

| 脚本 | 说明 | 推荐场景 | 完整路径 |
|------|------|----------|----------|
| **start-minimal-dev.sh** | 最小化开发环境（核心服务） | 快速本地开发测试 | [deploy/scripts/start-minimal-dev.sh](deploy/scripts/start-minimal-dev.sh) |
| **start-full-dev.sh** | 完整开发环境（所有服务） | 完整功能测试开发 | [deploy/scripts/start-full-dev.sh](deploy/scripts/start-full-dev.sh) |
| **start-full-prod.sh** | 完整生产环境准备 | 生产环境部署准备 | [deploy/scripts/start-full-prod.sh](deploy/scripts/start-full-prod.sh) |
| **start-observability-only.sh** | 仅可观测性服务 | 监控调试场景 | [deploy/scripts/start-observability-only.sh](deploy/scripts/start-observability-only.sh) |
| **reset-env.sh** | 一键重置环境 | 环境清理重置 | [deploy/scripts/reset-env.sh](deploy/scripts/reset-env.sh) |
| **status.sh** | 查看服务状态 | 日常运维检查 | [deploy/scripts/status.sh](deploy/scripts/status.sh) |
| **open-nav.sh** | 生成系统导航页面 | 快速访问所有服务 | [deploy/scripts/open-nav.sh](deploy/scripts/open-nav.sh) |
| **stop-all.sh** | 停止所有服务 | 环境关闭 | [deploy/scripts/stop-all.sh](deploy/scripts/stop-all.sh) |
| **clean-all-data.sh** | 清理所有数据 | 数据清理 | [deploy/scripts/clean-all-data.sh](deploy/scripts/clean-all-data.sh) |
| **start-local-docker-compose.sh** | 启动本地基础服务 | 快速启动基础组件 | [deploy/scripts/start-local-docker-compose.sh](deploy/scripts/start-local-docker-compose.sh) |
| **start-atom-services.sh** | 启动原子服务 | 原子服务启动 | [deploy/scripts/start-atom-services.sh](deploy/scripts/start-atom-services.sh) |
| **start-apps.sh** | 启动应用系统 | 应用系统启动 | [deploy/scripts/start-apps.sh](deploy/scripts/start-apps.sh) |
| **deploy-swarm.sh** | Docker Swarm 集群部署 | Swarm 集群部署 | [deploy/scripts/deploy-swarm.sh](deploy/scripts/deploy-swarm.sh) |
| **clean-swarm.sh** | 清理 Swarm 集群 | Swarm 集群清理 | [deploy/scripts/clean-swarm.sh](deploy/scripts/clean-swarm.sh) |

### 📋 快速上手示例

```bash
# 1. 最小化开发环境快速启动
./deploy/scripts/start-minimal-dev.sh

# 2. 完整开发环境一键启动
./deploy/scripts/start-full-dev.sh

# 3. 查看服务状态
./deploy/scripts/status.sh

# 4. 打开系统导航页面
./deploy/scripts/open-nav.sh

# 5. 停止所有服务
./deploy/scripts/stop-all.sh
```

### 📌 脚本说明

#### 🟢 开发环境

| 脚本 | 启动组件 | 资源需求 | 启动时间 |
|------|----------|----------|----------|
| `start-minimal-dev.sh` | Nacos, MySQL, Redis, RabbitMQ, Prometheus, Grafana | 低 | 约 30 秒 |
| `start-full-dev.sh` | 全部基础服务 + 原子服务 + 应用系统 | 中 | 约 2-3 分钟 |

#### 🔵 生产/调试环境

| 脚本 | 适用场景 | 包含内容 |
|------|----------|----------|
| `start-full-prod.sh` | 生产环境完整部署 | 所有组件，包含安全检查 |
| `start-observability-only.sh` | 仅监控调试 | 可观测性完整套件 |

#### 🛠️ 运维工具

| 脚本 | 功能 |
|------|------|
| `reset-env.sh` | 停止所有服务，清理数据，重新启动 |
| `status.sh` | 查看运行中/停止的容器、资源使用 |
| `stop-all.sh` | 停止所有运行中的服务 |
| `clean-all-data.sh` | 清理持久化数据 |
| `open-nav.sh` | 生成并打开系统导航HTML页面 |

### Kubernetes Helm 部署

#### 1. 准备集群与命名空间

```bash
# 创建命名空间
kubectl create namespace monitoring
kubectl create namespace logging
kubectl create namespace istio-system
kubectl create namespace middleware
```

#### 2. 部署基础服务

```bash
cd deploy/helm/basic

# 存储服务
helm install prometheus prometheus -n monitoring
helm install elasticsearch elasticsearch -n logging
helm install redis redis -n middleware
helm install mysql mysql -n middleware

# 消息队列
helm install kafka kafka -n middleware
helm install rabbitmq rabbitmq -n middleware

# 注册与配置中心
helm install nacos nacos -n middleware

# 可观测性服务
helm install skywalking skywalking -n monitoring
helm install monitoring alertmanager-grafana -n monitoring
helm install logging logstash-kibana -n logging

# 限流熔断
helm install sentinel sentinel-dashboard -n middleware
```

#### 3. 部署服务网格 (可选)

```bash
# 安装 Istio
helm install istio istio -n istio-system

# 启用自动 Sidecar 注入
kubectl label namespace default istio-injection=enabled
```

#### 4. 部署业务服务

```bash
cd ../atom

helm install user-center user-center -n default
helm install oauth-center oauth-center -n default
helm install content-center content-center -n default
helm install job-center job-center -n default
helm install admin-center admin-center -n default
```

#### 5. 访问服务

```bash
# 查看 Ingress 访问地址
kubectl get ingress -n monitoring
kubectl get ingress -n logging
```

## 可观测性指南

### 1. 指标监控 (Prometheus + Grafana)

#### 配置 Prometheus 采集

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'nacos'
    static_configs:
      - targets: ['nacos:8848']

  - job_name: 'skywalking'
    static_configs:
      - targets: ['skywalking-oap:12800']

  - job_name: 'springboot'
    metrics_path: '/actuator/prometheus'
    kubernetes_sd_configs:
      - role: pod
```

#### Grafana 预配置面板

- **基础设施面板**: CPU、内存、磁盘、网络
- **Spring Boot 面板**: JVM、请求、错误、延迟
- **数据库面板**: MySQL / PostgreSQL 指标
- **消息队列面板**: Kafka / RabbitMQ 指标

### 2. 链路追踪 (SkyWalking)

#### 集成 SkyWalking Agent

```bash
# Java 应用启动参数
java -javaagent:/path/to/skywalking-agent.jar \
     -Dskywalking.agent.service_name=structure-cloud \
     -Dskywalking.collector.backend_service=skywalking-oap:11800 \
     -Dskywalking.trace.sample_n_per_3_secs=-1 \
     -Dskywalking.logging.level=INFO \
     -jar app.jar
```

#### SkyWalking 核心功能

- **拓扑图**: 服务依赖关系可视化
- **追踪**: 请求链路追踪与性能分析
- **告警**: 服务异常告警
- **性能剖析**: 慢 SQL / 慢接口分析

### 3. 日志聚合 (ELK Stack)

#### Logstash 输入配置

```conf
input {
  beats { port => 5044 }
  tcp { port => 5000 codec => json }
  kafka {
    bootstrap_servers => "kafka:9092"
    topics => ["app-logs"]
  }
}
```

#### 日志查询与分析

使用 Kibana 查询日志:
- 按服务、级别、时间过滤
- 按 trace_id 关联链路追踪
- 日志聚合与可视化

## 安全与高可用

### Istio mTLS 双向认证

```yaml
# PeerAuthentication
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
spec:
  mtls:
    mode: STRICT
```

### Sentinel 流量控制规则

```yaml
# 流量控制配置
FlowRule:
  - resource: "com.example.service"
    grade: 1
    count: 10
    strategy: 0
    controlBehavior: 0
```

### 告警规则配置

```yaml
groups:
  - name: service_health
    rules:
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "服务 {{ $labels.instance }} 已停止"
```

## 运维操作指南

### 服务扩容与缩容

**Docker Compose**:
```bash
# 更新副本数
docker-compose up -d --scale user-center=3
```

**Kubernetes**:
```bash
kubectl scale deployment user-center --replicas=3
```

### 日志查看与清理

```bash
# 查看实时日志
docker logs -f structure-user-center

# 清理旧日志
find /path/to/logs -mtime +7 -delete
```

### 备份与恢复

```bash
# MySQL 备份
docker exec structure-mysqldump -uroot -p123456 structure > backup.sql

# 恢复
docker exec -i structure-mysql -uroot -p123456 structure < backup.sql
```

## CI/CD 流水线

### GitHub Actions (参考)

```yaml
# .github/workflows/deploy.yml
name: CI/CD Pipeline
on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build
        run: mvn clean package
        
      - name: Build Image
        run: docker build -t registry.example.com/service:${{ github.sha }} .
        
      - name: Push Image
        uses: docker/build-push-action@v2
        with:
          push: true
          
      - name: Deploy
        run: |
          helm upgrade service deploy/helm/atom/service --install
```

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 许可证

MIT License

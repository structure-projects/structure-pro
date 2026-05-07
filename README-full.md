# structure-cloud-pro

## 项目简介

structure-cloud-pro 是一个基于云原生的微服务架构脚手架方案，提供完整的容器化部署和管理方案，涵盖从开发、构建、部署到运维的全流程最佳实践。

## 项目导航

structure-projects 项目组包含多个子项目，涵盖微服务架构的各个领域：

### 🏠 项目首页

| 项目 | 链接 |
|------|------|
| **Structure Projects** | [https://github.com/structure-projects](https://github.com/structure-projects) |

### 🔧 基础框架

| 项目 | 描述 | 链接 |
|------|------|------|
| **structure-boot** | 单体项目的启动器 | [structure-projects/structure-boot](https://github.com/structure-projects/structure-boot) |
| **structure-cloud** | 微服务版本依赖 | [structure-projects/structure-cloud](https://github.com/structure-projects/structure-cloud) |
| **structure-security** | 安全认证框架 | [structure-projects/structure-security](https://github.com/structure-projects/structure-security) |
| **structure-yudao** | 宇道框架 | [structure-projects/structure-yudao](https://github.com/structure-projects/structure-yudao) |

### 👤 用户与认证中心

| 项目 | 描述 | 链接 |
|------|------|------|
| **user-center** | 用户中心服务 | [structure-projects/structure-admin](https://github.com/structure-projects/structure-admin) |
| **oauth-center** | 认证授权中心 | [structure-projects/structure-security](https://github.com/structure-projects/structure-security) |

### 💬 消息与任务中心

| 项目 | 描述 | 链接 |
|------|------|------|
| **structure-message** | 消息中心 | [structure-projects/structure-message](https://github.com/structure-projects/structure-message) |
| **structure-job** | 调度中心 | [structure-projects/structure-job](https://github.com/structure-projects/structure-job) |

### 🖥️ 前端应用

| 项目 | 描述 | 链接 |
|------|------|------|
| **structure-admin-ui** | 管理后台前端 | [structure-projects/structure-admin-ui](https://github.com/structure-projects/structure-admin-ui) |
| **structure-web-ui** | 基础前端框架 | [structure-projects/structure-web-ui](https://github.com/structure-projects/structure-web-ui) |
| **ruoyi-ui** | 若依前台 | [structure-projects/ruoyi-ui](https://github.com/structure-projects/ruoyi-ui) |

### 🔌 扩展与插件

| 项目 | 描述 | 链接 |
|------|------|------|
| **structure-plugin** | 扩展插件 | [structure-projects/structure-plugin](https://github.com/structure-projects/structure-plugin) |
| **structure-netty** | Netty 通信框架 | [structure-projects/structure-netty](https://github.com/structure-projects/structure-netty) |

### 🚀 部署与运维

| 项目 | 描述 | 链接 |
|------|------|------|
| **docker-compose** | Docker Compose 部署配置 | [structure-projects/docker-compose](https://github.com/structure-projects/docker-compose) |
| **kubernetes** | Kubernetes 部署配置 | [structure-projects/kubernetes](https://github.com/structure-projects/kubernetes) |

### 📦 若依集成项目

| 项目 | 描述 | 链接 |
|------|------|------|
| **ruoyi-pro** | 若依项目实战 | [structure-projects/ruoyi-pro](https://github.com/structure-projects/ruoyi-pro) |
| **structure-ruoyi** | 集成若依框架 | [structure-projects/structure-ruoyi](https://github.com/structure-projects/structure-ruoyi) |

> 💡 更多项目请访问 [structure-projects](https://github.com/structure-projects) 组织页面查看完整项目列表。

## 技术架构

### 整体架构图

```
┌───────────────────────────────────────────────────────────────────────┐
│                          接入层 (Ingress)                              │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐            │
│  │   Kong       │  │   Istio       │  │   HTTPS       │            │
│  │   Gateway    │  │   Gateway     │  │   443/80      │            │
│  └───────────────┘  └───────────────┘  └───────────────┘            │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                    服务网格层 (Service Mesh)                          │
│                   Istio 流量管理 / mTLS 安全                          │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                        网关层 (Gateway)                               │
│                 ┌───────────────────────────────┐                    │
│                 │  structure-cloud-gateway      │                    │
│                 │  - 路由转发                   │                    │
│                 │  - 限流熔断                   │                    │
│                 │  - 认证鉴权                   │                    │
│                 └───────────────────────────────┘                    │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                    业务服务层 (Business Services)                      │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │
│ │ user-center│ │oauth-center │ │content-center│ │ job-center  │    │
│ │   用户中心  │ │   认证授权  │ │   内容中心  │ │ 任务调度    │    │
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘    │
│ ┌─────────────┐ ┌───────────────────────────────────────────────┐  │
│ │admin-center │ │ content-manager-system / manager-system       │  │
│ │   管理中心  │ │            应用系统聚合层                      │  │
│ └─────────────┘ └───────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                    基础设施层 (Infrastructure)                        │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  注册与配置     │  Nacos: 服务注册 / 配置中心              │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  消息队列       │  Kafka / RabbitMQ / RocketMQ / EMQX      │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  缓存           │  Redis / Memcached: 分布式缓存 / Session共享  │ │
│ └───────────────────────────────────────────────────────────────────┘ │
│ ┌───────────────────────────────────────────────────────────────────┐ │
│ │  数据存储       │  MySQL / PostgreSQL / MongoDB / MinIO /    │ │
│ │                 │  MariaDB / SQL Server / Neo4j / ClickHouse  │ │
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
│                    可观测性层 (Observability)                         │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │
│ │  Prometheus │ │  Grafana   │ │  AlertManager │ │  Kibana   │    │
│ │  监控指标   │ │  可视化    │ │  告警通知     │ │  日志查询  │    │
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘    │
│ ┌─────────────┐ ┌─────────────┐                                      │
│ │  SkyWalking │ │  Logstash  │                                      │
│ │  链路追踪   │ │  日志收集  │                                      │
│ └─────────────┘ └─────────────┘                                      │
└───────────────────────────────────────────────────────────────────────┘
                              ↓
┌───────────────────────────────────────────────────────────────────────┐
│                    基础设施 (Infrastructure)                          │
│               Docker / Kubernetes / Helm / Nomad                      │
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
| **消息队列** | RocketMQ | latest | 阿里巴巴开源消息队列 |
| **消息协议** | EMQX | latest | MQTT 物联网消息代理 |
| **分布式缓存** | Redis | latest | 分布式缓存 / Session共享 |
| **分布式缓存** | Memcached | latest | 高性能内存缓存 |
| **时序数据库** | InfluxDB | latest | 指标存储 |

#### 数据存储

| 组件 | 技术选型 | 版本 | 功能 |
|------|----------|------|------|
| **关系型数据库** | MySQL | latest | 业务数据存储 |
| **关系型数据库** | MySQL 5.x | latest | 兼容旧版本 |
| **关系型数据库** | PostgreSQL | latest | 业务数据存储 |
| **关系型数据库** | MariaDB | latest | MySQL 开源分支 |
| **关系型数据库** | SQL Server | latest | 微软商业数据库 |
| **文档数据库** | MongoDB | latest | 文档存储 |
| **图数据库** | Neo4j | latest | 图数据存储 |
| **分布式搜索引擎** | Elasticsearch | 8.16.0 | 搜索引擎 |
| **列式存储** | ClickHouse | latest | OLAP 分析 |
| **对象存储** | MinIO | latest | 对象存储服务 |
| **目录服务** | OpenLDAP | latest | 轻量级目录访问协议 |

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
| **容器编排** | Docker Swarm / Kubernetes / Nomad | 1.20+ | 容器编排管理 |
| **包管理** | Helm | 3.0+ | Kubernetes 包管理 |

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
│   Gateway        │              │  Internal Services │
│  Services        │              │  (User, Content, │
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
│  Prometheus  │  Grafana  │  SkyWalking  │  ELK  │
└──────────────────────────────────────────────────┘
```

## 项目结构

### 目录结构

```
structure-cloud-pro/
├── structure-monitoring-center/    # 监控中心模块
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── cn/structured/monitoring/
│   │       └── resources/
│   │           ├── application.yaml
│   │           └── bootstrap.yaml
│   └── pom.xml
├── deploy/
│   ├── docker/                     # Docker 部署文档
│   │   ├── docker-swarm.md         # Swarm 集群高可用部署
│   │   ├── on-line-docker.md       # 在线 Docker 安装
│   │   └── off-line-docker.md      # 离线 Docker 安装
│   ├── docker-compose/
│   │   ├── basic/                  # 基础服务
│   │   │   ├── nacos/
│   │   │   ├── redis/
│   │   │   ├── mysql/
│   │   │   ├── mysql5/
│   │   │   ├── postgresql/
│   │   │   ├── mongodb/
│   │   │   ├── mariadb/
│   │   │   ├── mssql/
│   │   │   ├── neo4j/
│   │   │   ├── minio/
│   │   │   ├── elasticsearch/
│   │   │   ├── logstash-kibana/
│   │   │   ├── prometheus/
│   │   │   ├── alertmanager-grafana/
│   │   │   ├── skywalking/
│   │   │   ├── sentinel-dashboard/
│   │   │   ├── kong-gateway/
│   │   │   ├── kafka/
│   │   │   ├── rabbitmq/
│   │   │   ├── rabbitmq3/
│   │   │   ├── rocketmq/
│   │   │   ├── emqx/
│   │   │   ├── influxdb/
│   │   │   ├── clickhouse/
│   │   │   ├── memcached/
│   │   │   ├── openldap/
│   │   │   └── seata/
│   │   ├── atom/                   # 原子服务
│   │   │   ├── user-center/
│   │   │   ├── oauth-center/
│   │   │   ├── content-center/
│   │   │   ├── job-center/
│   │   │   └── admin-center/
│   │   ├── apps/                   # 应用系统
│   │   │   ├── content-manager-system/
│   │   │   └── manager-system/
│   │   ├── view/                   # 前端应用
│   │   │   ├── web-pc-cms-ui/
│   │   │   └── web-pc-manager-ui/
│   │   ├── dev-ops-tools/          # 开发运维工具
│   │   │   ├── it-tools/
│   │   │   ├── netclient/
│   │   │   └── netgateway/
│   │   ├── scripts/
│   │   ├── .env
│   │   ├── genEnv.sh
│   │   └── readme.md
│   ├── helm/                       # Helm Charts 部署
│   │   ├── basic/                  # 基础服务 Helm
│   │   ├── atom/                   # 原子服务 Helm
│   │   ├── apps/                   # 应用系统 Helm
│   │   ├── view/                   # 前端应用 Helm
│   │   ├── dev-ops-tools/          # 开发运维工具 Helm
│   │   └── readme.md
│   ├── nomad/                      # Nomad 部署配置
│   │   ├── jobs/                   # Nomad Job 定义
│   │   │   ├── basic/
│   │   │   ├── atom/
│   │   │   ├── apps/
│   │   │   ├── view/
│   │   │   ├── dev-ops-tools/
│   │   │   └── template/
│   │   ├── config/                 # Nomad 配置文件
│   │   ├── systemd/                # Nomad Systemd 服务
│   │   ├── generate_nomad_jobs.py  # 生成 Nomad Job 脚本
│   │   └── convert_compose_to_nomad.py
│   ├── docker-deploy.md
│   └── k8s-deploy.md
├── nginx.conf                      # Nginx 配置文件
├── pom.xml                         # Maven 父 POM
├── LICENSE
├── README.md
└── README-full.md
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

#### 开发运维工具 (DevOps Tools)

| 工具名称 | 功能描述 |
|----------|----------|
| **it-tools** | 在线工具箱，包含各种开发运维常用工具 |
| **netclient** | 网络客户端工具 |
| **netgateway** | 网络网关工具 |

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
| **Redis** | 分布式缓存 | 6379 |
| **Memcached** | 内存缓存 | 11211 |
| **MySQL** | 关系型数据库 | 3306 |
| **MySQL 5** | MySQL 5.x 版本 | 3306 |
| **PostgreSQL** | 关系型数据库 | 5432 |
| **MariaDB** | MySQL 开源分支 | 3306 |
| **SQL Server** | 微软商业数据库 | 1433 |
| **MongoDB** | 文档数据库 | 27017 |
| **Neo4j** | 图数据库 | 7474, 7687 |
| **MinIO** | 对象存储 | 9000 |
| **Kafka** | 消息队列 | 9092 |
| **RabbitMQ** | 消息队列 | 5672, 15672 |
| **RabbitMQ 3** | RabbitMQ 3.x 版本 | 5672, 15672 |
| **RocketMQ** | 消息队列 | 9876, 10909, 10911 |
| **EMQX** | MQTT 消息代理 | 1883, 8083, 8883, 18083 |
| **InfluxDB** | 时序数据库 | 8086 |
| **ClickHouse** | 列式存储数据库 | 8123, 9000 |
| **Seata** | 分布式事务 | 8091 |
| **OpenLDAP** | 目录服务 | 389, 636 |

## 快速开始

### 环境要求

- **Docker**: 20.10+
- **Docker Compose**: 1.29+
- **Kubernetes**: 1.20+ (可选)
- **Helm**: 3.0+ (可选)
- **Nomad**: 1.5+ (可选)

### Docker Compose 部署

#### 部署示例

```bash
cd <service-directory>
sh ./scripts/init.sh
# docker-compose 部署
docker-compose up -d
```

#### 1. 准备网络与环境

```bash
# 创建网络
docker network create structure-cloud-work --driver overlay

# 进入项目目录
cd deploy/docker-compose
```

#### 2. 启动基础服务

```bash
cd basic/prometheus
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# elasticsearch
cd basic/elasticsearch
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# redis
cd basic/redis
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# mysql
cd basic/mysql
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# kafka
cd basic/kafka
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# rabbitmq
cd basic/rabbitmq
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# nacos
cd basic/nacos
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# skywalking
cd basic/skywalking
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# alertmanager-grafana
cd basic/alertmanager-grafana
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# logstash-kibana
cd basic/logstash-kibana
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# sentinel-dashboard
cd basic/sentinel-dashboard
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# kong-gateway
cd basic/kong-gateway
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# 更多可选服务
# minio, mongodb, postgresql, mariadb, mssql, neo4j, clickhouse
# influxdb, emqx, rocketmq, rabbitmq3, memcached, openldap, seata
```

#### 3. 启动原子服务

```bash
# user-center
cd atom/user-center
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# oauth-center
cd atom/oauth-center
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# content-center
cd atom/content-center
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# job-center
cd atom/job-center
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# admin-center
cd atom/admin-center
sh ./scripts/init.sh
docker-compose up -d
cd ../..
```

#### 4. 启动应用系统

```bash
# content-manager-system
cd apps/content-manager-system
sh ./scripts/init.sh
docker-compose up -d
cd ../..

# manager-system
cd apps/manager-system
sh ./scripts/init.sh
docker-compose up -d
cd ../..
```

#### 5. 验证部署

- **Nacos 控制台**: http://localhost:8848/nacos (nacos/nacos)
- **SkyWalking UI**: http://localhost:8080
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Kibana**: http://localhost:5601
- **Sentinel Dashboard**: http://localhost:8858 (sentinel/sentinel)
- **Kong Admin**: http://localhost:8001

### Docker Swarm 集群部署

#### 部署示例

```bash
cd <service-directory>
sh ./scripts/init.sh
# docker-swarm 部署
docker stack deploy -c service.yaml <service-name>
```

#### 1. 准备网络与环境

```bash
# 进入项目目录
cd deploy/docker-compose

# 初始化 Docker Swarm (如果尚未初始化)
docker swarm init --advertise-addr <YOUR_IP>

# 创建 Overlay 网络
docker network create --driver overlay --attachable structure-cloud-work
```

#### 2. 部署基础服务

```bash
# prometheus
cd basic/prometheus
sh ./scripts/init.sh
docker stack deploy -c service.yaml prometheus
cd ../..

# elasticsearch
cd basic/elasticsearch
sh ./scripts/init.sh
docker stack deploy -c service.yaml elasticsearch
cd ../..

# redis
cd basic/redis
sh ./scripts/init.sh
docker stack deploy -c service.yaml redis
cd ../..

# mysql
cd basic/mysql
sh ./scripts/init.sh
docker stack deploy -c service.yaml mysql
cd ../..

# kafka
cd basic/kafka
sh ./scripts/init.sh
docker stack deploy -c service.yaml kafka
cd ../..

# rabbitmq
cd basic/rabbitmq
sh ./scripts/init.sh
docker stack deploy -c service.yaml rabbitmq
cd ../..

# nacos
cd basic/nacos
sh ./scripts/init.sh
docker stack deploy -c service.yaml nacos
cd ../..

# skywalking
cd basic/skywalking
sh ./scripts/init.sh
docker stack deploy -c service.yaml skywalking
cd ../..

# alertmanager-grafana
cd basic/alertmanager-grafana
sh ./scripts/init.sh
docker stack deploy -c service.yaml alertmanager-grafana
cd ../..

# logstash-kibana
cd basic/logstash-kibana
sh ./scripts/init.sh
docker stack deploy -c service.yaml logstash-kibana
cd ../..

# sentinel-dashboard
cd basic/sentinel-dashboard
sh ./scripts/init.sh
docker stack deploy -c service.yaml sentinel
cd ../..

# kong-gateway
cd basic/kong-gateway
sh ./scripts/init.sh
docker stack deploy -c service.yaml kong-gateway
cd ../..
```

#### 3. 部署原子服务

```bash
# user-center
cd atom/user-center
sh ./scripts/init.sh
docker stack deploy -c service.yaml user-center
cd ../..

# oauth-center
cd atom/oauth-center
sh ./scripts/init.sh
docker stack deploy -c service.yaml oauth-center
cd ../..

# content-center
cd atom/content-center
sh ./scripts/init.sh
docker stack deploy -c service.yaml content-center
cd ../..

# job-center
cd atom/job-center
sh ./scripts/init.sh
docker stack deploy -c service.yaml job-center
cd ../..

# admin-center
cd atom/admin-center
sh ./scripts/init.sh
docker stack deploy -c service.yaml admin-center
cd ../..
```

#### 4. 部署应用系统

```bash
# content-manager-system
cd apps/content-manager-system
sh ./scripts/init.sh
docker stack deploy -c service.yaml content-manager-system
cd ../..

# manager-system
cd apps/manager-system
sh ./scripts/init.sh
docker stack deploy -c service.yaml manager-system
cd ../..
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

### Nomad 部署

#### 部署示例

```bash
# 部署单个 Job
cd deploy/nomad/jobs/basic
nomad job run <service.nomad>
```

#### 1. 准备 Nomad 环境

```bash
# 进入 Nomad 配置目录
cd deploy/nomad/config

# 启动 Nomad 服务器和客户端（需先安装 Nomad）
# 具体安装请参考 Nomad 官方文档
```

#### 2. 部署基础服务

```bash
cd deploy/nomad/jobs/basic

# 部署 Nacos
nomad job run nacos.nomad

# 部署 Redis
nomad job run redis.nomad

# 部署 MySQL
nomad job run mysql.nomad

# 部署更多基础服务...
```

#### 3. 部署原子服务

```bash
cd deploy/nomad/jobs/atom

# 部署 user-center
nomad job run user-center.nomad

# 部署 oauth-center
nomad job run oauth-center.nomad

# 部署更多原子服务...
```

#### 4. 部署应用系统

```bash
cd deploy/nomad/jobs/apps

# 部署 content-manager-system
nomad job run content-manager-system.nomad

# 部署 manager-system
nomad job run manager-system.nomad
```

#### 5. Nomad 管理命令

```bash
# 查看所有作业
nomad job status

# 查看特定作业状态
nomad job status <job-name>

# 停止作业
nomad job stop <job-name>

# 查看分配状态
nomad alloc status <alloc-id>

# 查看分配日志
nomad alloc logs <alloc-id>

# 查看节点状态
nomad node status
```

## 🚀 脚本体系

项目脚本按功能分为以下几类：

### 📦 1. 快速启动脚本 (quick-start)

一键启动完整环境，自动扫描目录部署所有服务。

| 脚本 | 说明 | 推荐场景 |
|------|------|----------|
| [start-minimal-dev.sh](deploy/scripts/start-minimal-dev.sh) | 最小化开发环境（核心服务） | 快速本地开发测试 |
| [start-full-dev.sh](deploy/scripts/start-full-dev.sh) | 完整开发环境（所有服务） | 完整功能测试开发 |
| [start-observability-only.sh](deploy/scripts/start-observability-only.sh) | 仅可观测性服务 | 监控调试场景 |

### 🛠️ 2. 运维工具脚本 (ops)

日常运维管理工具。

| 脚本 | 说明 |
|------|------|
| [stop-all.sh](deploy/scripts/stop-all.sh) | 停止所有服务 |
| [reset-env.sh](deploy/scripts/reset-env.sh) | 一键重置环境（停止+清理+重启） |
| [clean-all-data.sh](deploy/scripts/clean-all-data.sh) | 清理所有数据 |
| [status.sh](deploy/scripts/status.sh) | 查看服务状态 |
| [open-nav.sh](deploy/scripts/open-nav.sh) | 生成系统导航页面 |

### 📦 3. Docker Compose 部署脚本 (docker-compose)

分阶段部署，支持独立启动某一类服务。

| 脚本 | 说明 |
|------|------|
| [start-local-docker-compose.sh](deploy/scripts/start-local-docker-compose.sh) | 启动基础服务 |
| [start-atom-services.sh](deploy/scripts/start-atom-services.sh) | 启动原子服务 |
| [start-apps.sh](deploy/scripts/start-apps.sh) | 启动应用系统 |

### 🐳 4. Docker Swarm 部署脚本 (swarm)

Docker Swarm 集群模式部署。

| 脚本 | 说明 |
|------|------|
| [deploy-swarm.sh](deploy/scripts/deploy-swarm.sh) | 部署 Swarm 集群 |
| [clean-swarm.sh](deploy/scripts/clean-swarm.sh) | 清理 Swarm 集群 |

### ☸️ 5. Kubernetes 部署脚本 (k8s)

Kubernetes 部署相关脚本。

| 脚本 | 说明 |
|------|------|
| [deploy-k8s-dev.sh](deploy/scripts/deploy-k8s-dev.sh) | K8s 开发环境部署 |

---

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

### 📌 脚本详细说明

#### 🟢 开发环境

| 脚本 | 启动组件 | 资源需求 | 启动时间 |
|------|----------|----------|----------|
| `start-minimal-dev.sh` | Nacos, MySQL, Redis, RabbitMQ, Prometheus, Grafana | 低 | 约 30 秒 |
| `start-full-dev.sh` | 全部基础服务 + 原子服务 + 应用系统 | 中 | 约 2-3 分钟 |

#### 🔵 调试环境

| 脚本 | 适用场景 | 包含内容 |
|------|----------|----------|
| `start-observability-only.sh` | 仅监控调试 | 可观测性完整套件 |

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

使用 Kibana 查询日志：
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

**Nomad**:
```bash
# 修改 Job 配置中的 count 参数
nomad job run <service.nomad>
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
docker exec structure-mysql mysqldump -uroot -p123456 structure > backup.sql

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

## 部署文档

项目包含以下详细部署文档：

- [Docker Swarm 集群高可用部署](deploy/docker/docker-swarm.md) - 包含环境配置、集群搭建、Portainer 管理等完整指南
- [在线 Docker 安装](deploy/docker/on-line-docker.md) - 在线环境下 Docker 和 Docker Compose 的安装步骤
- [离线 Docker 安装](deploy/docker/off-line-docker.md) - 离线环境下 Docker 的安装和配置方法

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 许可证

Apache License 2.0 - see [LICENSE](LICENSE) 文件

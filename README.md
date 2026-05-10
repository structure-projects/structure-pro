# structure-pro

云原生微服务架构脚手架，提供完整的容器化部署和管理方案。

## 🚀 快速开始

### 环境要求

- **Docker**: 20.10+
- **Docker Compose**: 1.29+

### 拉取子模块

项目使用 Git 子模块管理多个组件，首次克隆后需要初始化并拉取子模块：

```bash
# 初始化并拉取所有子模块（推荐）
git submodule update --init --recursive

# 查看子模块状态
git submodule status

# 更新子模块到远程最新版本
git submodule update --remote
```

#### 子模块列表

| 子模块 | 说明 |
|--------|------|
| structure-gateway | API 网关 |
| structure-oauth | OAuth 认证中心 |
| structure-user | 用户中心 |
| structure-admin | 管理中心后端 |
| structure-admin-ui | 管理中心前端 |
| structure-boot | Spring Boot 启动器 |
| structure-cloud | 微服务依赖 |
| structure-job | 定时任务 |
| structure-security | 安全模块 |
| structure-docs | 文档 |
| somcli | 命令行工具 |
| structure-monitor | 监控模块 |
| structure-message | 消息模块 |
| structure-ops | 运维模块 |
| structure-alert | 告警模块 |
| structure-audit | 审计模块 |
| structure-member | 会员模块 |
| structure-account | 账户模块 |
| structure-order | 订单模块 |
| structure-product | 商品模块 |
| structure-seller | 卖家模块 |
| structure-risk | 风控模块 |
| structure-pay | 支付模块 |
| structure-content | 内容模块 |
| structure-advertising | 广告模块 |
| structure-incentive | 激励模块 |
| structure-sso | 单点登录 |
| structure-portal | 门户模块 |
| structure-bpm | 工作流模块 |
| structure-data | 数据模块 |
| structure-iam | 身份访问管理 |
| structure-gateway-adapter | 网关适配器 |
| structure-crm | 客户关系管理 |
| structure-erp | 企业资源计划 |
| structure-oa | 办公自动化 |
| structure-hr | 人力资源管理 |
| structure-agent | 代理模块 |

### 一键启动

```bash
# 最小化开发环境（核心服务）
./deploy/scripts/start-minimal-dev.sh

# 完整开发环境（所有服务）
./deploy/scripts/start-full-dev.sh

# 停止所有服务
./deploy/scripts/stop-all.sh
```

### 访问地址

| 服务 | 地址 | 凭据 |
|------|------|------|
| Nacos 控制台 | http://localhost:8848/nacos | nacos/nacos |
| Grafana | http://localhost:3000 | admin/admin123 |
| SkyWalking UI | http://localhost:8080 | - |
| Kibana | http://localhost:5601 | - |
| Sentinel Dashboard | http://localhost:8858 | sentinel/sentinel |
| Kong Admin | http://localhost:8001 | - |

## 🏗️ 技术架构

```
┌─────────────────────────────────────────────────────┐
│                    接入层 (Ingress)                  │
│           Kong Gateway / Istio Gateway              │
└─────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                    服务网格层                        │
│              Istio / Service Mesh                   │
└─────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                    业务服务层                        │
│  user-center  oauth-center  content-center  job-center │
│            admin-center / 应用系统聚合层              │
└─────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                    基础设施层                        │
│  Nacos  │  Kafka / RabbitMQ  │  Redis  │  MySQL   │
│  Elasticsearch  │  Sentinel  │  SkyWalking         │
└─────────────────────────────────────────────────────┘
```

### 技术栈

| 类别 | 组件 |
|------|------|
| **微服务框架** | Spring Cloud / Spring Boot |
| **服务注册** | Nacos 2.2.3 |
| **消息队列** | Kafka / RabbitMQ / RocketMQ / EMQX |
| **缓存** | Redis / Memcached |
| **数据库** | MySQL / PostgreSQL / MongoDB / MariaDB / SQL Server / Neo4j |
| **搜索引擎** | Elasticsearch 8.16.0 |
| **时序数据库** | InfluxDB / ClickHouse |
| **对象存储** | MinIO |
| **分布式事务** | Seata |
| **监控** | Prometheus + Grafana |
| **链路追踪** | SkyWalking 9.5.0 |
| **日志** | ELK Stack (Elasticsearch + Logstash + Kibana) |
| **容器编排** | Docker Swarm / Kubernetes / Helm / Nomad |
| **API网关** | Kong Gateway |
| **限流熔断** | Sentinel 1.8.8 |

## 📁 项目结构

```
structure-cloud-pro/
├── structure-monitoring-center/    # 监控中心模块
├── deploy/
│   ├── docker/                     # Docker 部署文档
│   │   ├── docker-swarm.md         # Swarm 集群部署指南
│   │   ├── on-line-docker.md       # 在线 Docker 安装
│   │   └── off-line-docker.md      # 离线 Docker 安装
│   ├── docker-compose/
│   │   ├── basic/                  # 基础服务
│   │   ├── atom/                   # 原子服务
│   │   ├── apps/                   # 应用系统
│   │   ├── view/                   # 前端应用
│   │   └── dev-ops-tools/          # 开发运维工具
│   ├── helm/                       # Helm Charts
│   └── nomad/                      # Nomad 部署配置
│       ├── jobs/                   # Nomad Job 定义
│       ├── config/                 # Nomad 配置文件
│       └── systemd/                # Nomad Systemd 服务
└── pom.xml                         # Maven 父 POM
```

### 服务分类

| 分类 | 服务 | 说明 |
|------|------|------|
| **原子服务** | user-center, oauth-center, content-center, job-center, admin-center | 核心业务能力 |
| **应用系统** | content-manager-system, manager-system | 业务聚合层 |
| **基础设施** | Nacos, Redis, MySQL, Kafka, Elasticsearch 等 | 中间件支持 |
| **开发运维工具** | it-tools, netclient, netgateway | 工具集 |

## 🚢 部署指南

### 部署流程

> ⚠️ **重要**: 部署任一服务前，必须先进入服务目录执行 `./scripts/init.sh` 初始化环境

```bash
# 进入服务目录
cd <service-directory>

# 初始化环境变量
sh ./scripts/init.sh

# Docker Compose 部署
docker-compose up -d

# Docker Swarm 部署
docker stack deploy -c service.yaml <service-name>

# Nomad 部署
nomad job run <job-file.nomad>
```

### Docker Compose 部署

```bash
# 1. 基础服务
cd deploy/docker-compose/basic/<service>
sh ./scripts/init.sh && docker-compose up -d

# 2. 原子服务
cd ../atom/<service>
sh ./scripts/init.sh && docker-compose up -d

# 3. 应用系统
cd ../apps/<service>
sh ./scripts/init.sh && docker-compose up -d
```

### Docker Swarm 集群部署

```bash
# 初始化 Swarm
docker swarm init --advertise-addr <YOUR_IP>
docker network create --driver overlay --attachable structure-cloud-work

# 基础服务
cd deploy/docker-compose/basic/<service>
sh ./scripts/init.sh && docker stack deploy -c service.yaml <stack-name>

# 原子服务
cd ../atom/<service>
sh ./scripts/init.sh && docker stack deploy -c service.yaml <stack-name>
```

### Nomad 部署

```bash
# 部署基础服务
cd deploy/nomad/jobs/basic
nomad job run <service.nomad>

# 部署原子服务
cd ../atom
nomad job run <service.nomad>

# 部署应用系统
cd ../apps
nomad job run <service.nomad>
```

## 📦 脚本体系

### 快速启动脚本

```bash
./deploy/scripts/start-minimal-dev.sh        # 最小化核心服务
./deploy/scripts/start-full-dev.sh           # 完整环境
./deploy/scripts/start-observability-only.sh # 仅监控
```

### 运维工具脚本

| 脚本 | 说明 |
|------|------|
| stop-all.sh | 停止所有服务 |
| reset-env.sh | 重置环境 |
| status.sh | 查看状态 |
| open-nav.sh | 导航页面 |

### 部署脚本

| 脚本 | 说明 |
|------|------|
| start-local-docker-compose.sh | 启动基础服务 |
| start-atom-services.sh | 启动原子服务 |
| start-apps.sh | 启动应用系统 |
| deploy-swarm.sh | Swarm 集群部署 |

### Swarm 管理命令

```bash
docker service ls                    # 查看服务
docker service ps <name>             # 服务状态
docker service logs <name>          # 查看日志
docker service scale <name>=3      # 扩容
docker stack rm <stack>             # 移除服务
```

### Nomad 管理命令

```bash
nomad job status                    # 查看作业状态
nomad job stop <job-name>           # 停止作业
nomad alloc status <alloc-id>      # 查看分配状态
nomad alloc logs <alloc-id>        # 查看日志
```

## 🛠️ 常用运维

### 服务管理

```bash
# 查看运行中的容器
docker ps

# 查看实时日志
docker logs -f <container-name>

# 进入容器
docker exec -it <container-name> /bin/bash
```

### 数据管理

```bash
# MySQL 备份
docker exec structure-mysql mysqldump -uroot -p123456 structure > backup.sql

# 清理数据
docker volume prune -f
```

## 📊 可观测性

### Prometheus + Grafana

- 指标监控: http://localhost:9090
- 可视化面板: http://localhost:3000

### SkyWalking

- 链路追踪: http://localhost:8080
- OAP 服务: localhost:11800

### ELK Stack

- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601

## 🔒 安全建议

- [ ] 修改所有默认密码
- [ ] 配置 HTTPS 访问
- [ ] 启用防火墙/安全组
- [ ] 配置日志轮转和备份

## 📚 更多资源

- [项目导航](https://github.com/structure-projects) - 更多相关项目
- [structure-boot](https://github.com/structure-projects/structure-boot) - 单体启动器
- [structure-cloud](https://github.com/structure-projects/structure-cloud) - 微服务依赖

---

## 📖 完整文档

更多详细内容请参考：
- [部署完整文档](README-full.md) - 包含完整的部署说明、技术架构、运维指南等
- [Docker Swarm 集群部署](docker/docker-swarm.md) - Swarm 高可用集群部署指南
- [在线 Docker 安装](docker/on-line-docker.md) - 在线环境 Docker 安装
- [离线 Docker 安装](docker/off-line-docker.md) - 离线环境 Docker 安装

## 📄 许可证

Apache License 2.0 - see [LICENSE](LICENSE) 文件

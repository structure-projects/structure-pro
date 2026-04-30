# structure-cloud-pro

## 项目简介

structure-cloud-pro 是一个基于云原生的微服务架构脚手架方案，提供完整的容器化部署和管理方案，涵盖从开发、构建、部署到运维的全流程最佳实践。

## 技术栈

### 后端技术
- **Java**: Java 8
- **微服务框架**: Spring Cloud
- **服务注册与发现**: Nacos
- **配置中心**: Nacos
- **API网关**: Kong Gateway / Spring Cloud Gateway
- **分布式事务**: Seata
- **消息队列**: RabbitMQ
- **缓存**: Redis
- **数据库**: MySQL、PostgreSQL
- **搜索引擎**: Elasticsearch
- **对象存储**: MinIO

### 容器化技术
- **容器运行时**: Docker
- **容器编排**: Docker Swarm、Kubernetes
- **包管理**: Helm

### 基础设施服务
- **服务注册中心**: Nacos
- **API网关**: Kong Gateway
- **分布式事务协调器**: Seata
- **消息中间件**: RabbitMQ
- **缓存服务**: Redis
- **数据库**: MySQL、PostgreSQL
- **搜索引擎**: Elasticsearch
- **对象存储**: MinIO

## 项目架构

### 服务模块

#### 原子服务 (Atom Services)
- **user-center**: 用户中心服务
- **oauth-center**: 认证授权中心
- **content-center**: 内容中心服务
- **job-center**: 任务调度中心
- **admin-center**: 管理中心服务

#### 应用系统 (Application Systems)
- **content-manager-system**: 内容管理系统
- **manager-system**: 管理系统

#### 前端应用 (Frontend)
- **web-pc-cms-ui**: 内容管理系统PC端
- **web-pc-manager-ui**: 管理系统PC端

#### 基础设施 (Infrastructure)
- **structure-cloud-gateway**: 网关服务
- **structure-monitoring-center**: 监控中心

### 目录结构

```
structure-cloud-pro/
├── structure-cloud-gateway/      # 网关服务
├── structure-monitoring-center/  # 监控中心
├── deploy/                       # 部署配置
│   ├── docker-compose/          # Docker Compose部署
│   │   ├── basic/               # 基础服务
│   │   ├── atom/                # 原子服务
│   │   ├── apps/                # 应用系统
│   │   └── view/                # 前端应用
│   └── helm/                    # Helm Charts部署
├── scripts/                      # 部署脚本
└── pom.xml
```

## 快速开始

### 环境要求
- Docker 20.10+
- Docker Compose 1.29+
- Kubernetes 1.20+ (可选)
- Helm 3.0+ (可选)

### Docker Compose 部署

1. 进入部署目录
```bash
cd deploy/docker-compose
```

2. 启动基础服务
```bash
cd basic
docker-compose up -d
```

3. 启动原子服务
```bash
cd ../atom
docker-compose -f user-center/docker-compose.yaml up -d
docker-compose -f oauth-center/docker-compose.yaml up -d
docker-compose -f content-center/docker-compose.yaml up -d
```

### Kubernetes Helm 部署

详见 [deploy/helm/readme.md](deploy/helm/readme.md)

## 文档

- [Docker Compose 部署文档](deploy/docker-compose/readme.md)
- [Helm 部署文档](deploy/helm/readme.md)
- [Kong Gateway 文档](deploy/docker-compose/basic/kong-gateway/readme.md)

## 待完善部分

详见 [TODO.md](TODO.md)

## 许可证

MIT License

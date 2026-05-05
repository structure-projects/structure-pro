# Serverless 部署配置

本目录包含项目中所有服务的 Serverless 部署配置，支持多个云厂商的部署方案。

## 目录结构

```
deploy/serverless-fc/
├── apps/                      # 应用系统
│   ├── content-manager-system/
│   │   ├── aliyun-fc.yaml
│   │   ├── tencent-scf.yaml
│   │   └── huawei-functiongraph.yaml
│   └── manager-system/
├── atom/                      # 原子服务
│   ├── admin-center/
│   ├── content-center/
│   ├── job-center/
│   ├── oauth-center/
│   └── user-center/
├── basic/                     # 基础服务
│   ├── clickhouse/
│   ├── elasticsearch/
│   ├── emqx/
│   ├── influxdb/
│   ├── kafka/
│   ├── kong-gateway/
│   ├── mariadb/
│   ├── memcached/
│   ├── minio/
│   ├── mongodb/
│   ├── mssql/
│   ├── mysql/
│   ├── mysql5/
│   ├── nacos/
│   ├── neo4j/
│   ├── nginx/
│   ├── openldap/
│   ├── postgres/
│   ├── postgresql/
│   ├── prometheus/
│   ├── rabbitmq/
│   ├── rabbitmq3/
│   ├── redis/
│   ├── rocketmq/
│   ├── seata/
│   └── sentinel-dashboard/
├── view/                      # 视图层
│   ├── web-pc-cms-ui/
│   └── web-pc-manager-ui/
├── dev-ops-tools/             # DevOps 工具
│   └── it-tools/
├── templates/                 # 配置模板
│   ├── aliyun-fc.yaml
│   ├── tencent-scf.yaml
│   └── huawei-functiongraph.yaml
├── generate_configs.py        # 配置生成脚本
└── README.md                  # 本文档
```

## 支持的云厂商

### 1. 阿里云 Function Compute (FC)

使用自定义容器部署，支持 HTTP 触发器。

**部署步骤：**

1. 安装 Serverless Devs 工具
```bash
npm install -g @serverless-devs/s
```

2. 配置阿里云账号
```bash
s config add
```

3. 进入服务目录并部署
```bash
cd deploy/serverless-fc/atom/admin-center
s deploy
```

4. 查看部署信息
```bash
s info
```

### 2. 腾讯云 Serverless Cloud Function (SCF)

使用自定义容器部署，支持 API 网关触发器。

**部署步骤：**

1. 安装 Serverless Framework
```bash
npm install -g serverless
```

2. 配置腾讯云账号
```bash
serverless config credentials --provider tencent
```

3. 根据模板修改配置文件并部署

### 3. 华为云 FunctionGraph

使用自定义容器部署，支持 API 网关触发器。

**部署步骤：**

1. 安装华为云 Serverless 工具
2. 配置华为云账号
3. 根据模板修改配置文件并部署

## 配置说明

每个服务目录下包含三个配置文件：
- `aliyun-fc.yaml` - 阿里云 FC 配置
- `tencent-scf.yaml` - 腾讯云 SCF 配置
- `huawei-functiongraph.yaml` - 华为云 FunctionGraph 配置

### 资源配置说明

- **Java 应用**：1 CPU / 2048 MB 内存
- **数据库服务**：1-2 CPU / 2048-4096 MB 内存
- **前端应用**：1 CPU / 1024 MB 内存
- **超时时间**：300-600 秒

## 服务列表

### 应用系统 (apps)
- content-manager-system - 内容管理系统
- manager-system - 管理系统

### 原子服务 (atom)
- admin-center - 管理中心
- content-center - 内容中心
- job-center - 任务中心
- oauth-center - 认证中心
- user-center - 用户中心

### 基础服务 (basic)
- clickhouse - ClickHouse 数据库
- elasticsearch - Elasticsearch 搜索引擎
- emqx - EMQX MQTT 消息队列
- influxdb - InfluxDB 时序数据库
- kafka - Kafka 消息队列
- kong-gateway - Kong API 网关
- mariadb - MariaDB 数据库
- memcached - Memcached 缓存
- minio - MinIO 对象存储
- mongodb - MongoDB 数据库
- mssql - Microsoft SQL Server
- mysql - MySQL 8.0 数据库
- mysql5 - MySQL 5.7 数据库
- nacos - Nacos 服务发现
- neo4j - Neo4j 图数据库
- nginx - Nginx Web 服务器
- openldap - OpenLDAP 目录服务
- postgres - PostgreSQL 数据库
- postgresql - PostgreSQL 数据库
- prometheus - Prometheus 监控
- rabbitmq - RabbitMQ 消息队列
- rabbitmq3 - RabbitMQ 3 消息队列
- redis - Redis 缓存
- rocketmq - RocketMQ 消息队列
- seata - Seata 分布式事务
- sentinel-dashboard - Sentinel 控制台

### 视图层 (view)
- web-pc-cms-ui - CMS 管理界面
- web-pc-manager-ui - 管理界面

### DevOps 工具 (dev-ops-tools)
- it-tools - IT 工具集

## 注意事项

1. 请确保容器镜像在云厂商的容器镜像服务中可访问
2. 根据实际需求调整资源配置（CPU、内存等）
3. 生产环境建议配置 VPC 网络以保证安全性
4. 建议配置日志服务以便查看应用运行日志
5. 部分有状态服务（如数据库）可能不适合直接部署在 Serverless 平台上，建议评估后再使用

## 重新生成配置

如需重新生成所有配置文件，可以运行：

```bash
cd deploy/serverless-fc
python3 generate_configs.py
```

## 更多信息

- [阿里云 FC 文档](https://help.aliyun.com/product/50980.html)
- [腾讯云 SCF 文档](https://cloud.tencent.com/product/scf)
- [华为云 FunctionGraph 文档](https://www.huaweicloud.com/product/functiongraph.html)

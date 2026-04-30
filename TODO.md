# 待完善部分清单

## 1. 核心服务模块开发

### 1.1 原子服务 (Atom Services)
- [ ] **user-center** - 用户中心服务
  - [ ] 用户注册/登录
  - [ ] 用户信息管理
  - [ ] 权限管理
  - [ ] 集成 OAuth 2.0

- [ ] **oauth-center** - 认证授权中心
  - [ ] OAuth 2.0 授权码模式
  - [ ] 密码模式
  - [ ] 客户端模式
  - [ ] 刷新令牌
  - [ ] JWT 令牌

- [ ] **content-center** - 内容中心服务
  - [ ] 内容 CRUD
  - [ ] 内容分类
  - [ ] 内容搜索
  - [ ] 内容审核

- [ ] **job-center** - 任务调度中心
  - [ ] 定时任务管理
  - [ ] 任务执行日志
  - [ ] 任务监控告警

- [ ] **admin-center** - 管理中心服务
  - [ ] 系统配置管理
  - [ ] 数据字典
  - [ ] 操作日志

### 1.2 应用系统 (Application Systems)
- [ ] **content-manager-system** - 内容管理系统
- [ ] **manager-system** - 管理系统

### 1.3 前端应用
- [ ] **web-pc-cms-ui** - 内容管理系统PC端
- [ ] **web-pc-manager-ui** - 管理系统PC端

### 1.4 基础设施
- [ ] **structure-cloud-gateway** - Spring Cloud Gateway 网关
  - [ ] 路由配置
  - [ ] 限流熔断
  - [ ] 日志记录
  - [ ] 认证鉴权

- [ ] **structure-monitoring-center** - 监控中心
  - [ ] 服务监控
  - [ ] 链路追踪
  - [ ] 日志聚合
  - [ ] 告警通知

## 2. 项目配置

### 2.1 Maven 依赖管理
- [ ] 完善父 pom.xml，统一管理依赖版本
- [ ] 添加 Spring Cloud 相关依赖
- [ ] 添加数据库驱动、ORM 框架
- [ ] 添加工具类库

### 2.2 服务配置
- [ ] 完善各服务的 application.yaml / bootstrap.yaml
- [ ] 配置 Nacos 服务注册与发现
- [ ] 配置 Nacos 配置中心
- [ ] 配置数据库连接
- [ ] 配置 Redis 连接
- [ ] 配置 RabbitMQ 连接

### 2.3 部署配置
- [ ] 完善 Docker Compose 配置
  - [ ] basic/docker-compose.yaml（基础服务统一编排）
  - [ ] 完善各服务的 .env 环境变量
  - [ ] 添加健康检查脚本

- [ ] 完善 Helm Charts 配置
  - [ ] 完善 values.yaml
  - [ ] 完善各服务模板
  - [ ] 添加 Ingress 配置

## 3. 文档完善

### 3.1 部署文档
- [ ] 完善 Docker Compose 部署文档
- [ ] 完善 Helm 部署文档
- [ ] 添加 Docker Swarm 部署文档
- [ ] 添加 K8s 手动部署文档

### 3.2 开发文档
- [ ] 项目架构设计文档
- [ ] 数据库设计文档
- [ ] API 文档
- [ ] 开发指南
- [ ] 代码规范

### 3.3 运维文档
- [ ] 监控告警方案
- [ ] 日志管理方案
- [ ] 备份恢复方案
- [ ] 故障排查手册

## 4. CI/CD 流水线

- [ ] 添加 GitHub Actions / GitLab CI 配置
- [ ] 构建镜像流水线
- [ ] 自动化测试流水线
- [ ] 自动部署流水线

## 5. 测试

- [ ] 单元测试
- [ ] 集成测试
- [ ] 接口测试
- [ ] 性能测试

## 6. 其他

- [ ] 添加 LICENSE 许可证文件
- [ ] 添加 CONTRIBUTING 贡献指南
- [ ] 添加 CHANGELOG 变更日志
- [ ] 项目架构图
- [ ] 系统拓扑图

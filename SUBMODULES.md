# 子模块列表

本项目使用 Git 子模块管理多个组件，完整列表如下：

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

## 子模块管理命令

```bash
# 初始化并拉取所有子模块
git submodule update --init --recursive

# 查看子模块状态
git submodule status

# 更新子模块到远程最新版本
git submodule update --remote
```

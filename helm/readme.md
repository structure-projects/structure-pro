## k8s helm包管理

### helm简介

在没使用 helm 之前，向 kubernetes 部署应用，我们要依次部署 deployment、svc 等，步骤较繁琐。 况且随着很多项目微服务化，复杂的应用在容器中部署以及管理显得较为复杂，helm 通过打包的方式，支持发布的版本管理和控制， 很大程度上简化了 Kubernetes 应用的部署和管理。

Helm 本质就是让 K8s 的应用管理（Deployment、Service 等）可配置，可以通过类似于传递环境变量的方式能动态生成。通过动态生成 K8s 资源清单文件（deployment.yaml、service.yaml）。然后调用 Kubectl 自动执行 K8s 资源部署。

### Helm 有三个重要的概念

Helm 有三个重要的概念：Chart 、Repository 和 Release

- Chart：Helm 的软件包，采用 TAR 格式。类似于 APT 的 DEB 包或者 YUM 的 RPM 包，其包含了一组定义 Kubernetes 资源相关的 YAML 文件。

- Repository（仓库）：Helm 的软件仓库，Repository 本质上是一个 Web 服务器，该服务器保存了一系列的 Chart 软件包以供用户下载，并且提供了一个该 Repository 的 Chart 包的清单文件以供查询。Helm 可以同时管理多个不同的 Repository。

- Release：使用 helm install 命令在 Kubernetes 集群中部署的 Chart 称为 Release。可以理解为 Helm 使用 Chart 包部署的一个应用实例。一个 chart 通常可以在同一个集群中安装多次。每一次安装都会创建一个新的 release。

### 安装helm
#### 下载 Helm 客户端：
访问 Helm 的 GitHub 标签页面 https://github.com/helm/helm/tags 来下载适合操作系统的 Helm 版本。例如，如果使用的是 Linux 系统，可以下载 helm-v3.6.0-linux-amd64.tar.gz。
#### 安装
```shell
tar -zxvf helm-v3.6.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
```
#### 验证
```shell
helm version
```
#### 添加仓库
```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable http://mirror.azure.cn/kubernetes/charts
helm repo add aliyun https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm repo add incubator https://charts.helm.sh/incubator
```
#### 更新仓库
```shell
helm repo update
```
#### 查看 Helm 仓库列表
```shell
helm repo list
```
#### 搜索 Chart
```shell
helm search repo stable
```
#### 移除某个仓库
```shell
helm repo remove incubator
```
#### 查看 Chart 信息
```shell
helm show chart stable/mysql     # 查看基本信息
helm show all stable/mysql     # 获取所有信息
```
#### 安装 Chart
使用 helm install 命令安装 Chart。可以指定一个 release 名称，或者使用 --generate-name 让 Helm 为生成一个随机名称。
```shell
helm install my-redis bitnami/redis [-n default]  # 指定 release 名称
helm install bitnami/redis --generate-name     # 自动生成 release 名称
```
### Helm Chart 自定义模板
#### Chart 结构概览
- Chart.yaml：包含 chart 的元数据。
- README.md：提供关于 chart 的信息和使用说明。
- templates：包含 chart 的模板文件，如：
- configurationFiles-configmap.yaml：配置文件的 ConfigMap 模板。
- deployment.yaml：Deployment 资源的模板。
- _helpers.tpl：辅助模板文件。
- initializationFiles-configmap.yaml：初始化文件的 ConfigMap 模板。
- NOTES.txt：安装后的说明和注意事项。
- pvc.yaml：PersistentVolumeClaim 资源的模板。
- secrets.yaml：Secret 资源的模板。
- serviceaccount.yaml：ServiceAccount 资源的模板。
- servicemonitor.yaml：ServiceMonitor 资源的模板。
- service.yaml：Service 资源的模板。
- ingress.yaml：Ingress 资源的模板。
- tests：包含测试相关的模板文件。
- values.yaml：包含 chart 的默认配置值。
####  创建自定义的 chart
使用 helm create 命令创建一个新的 Helm chart，例如 nginx。
```shell
helm create nginx
tree nginx
nginx
├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

```

cat nginx/templates/deployment.yaml
#在 templates 目录下 yaml 文件模板中的变量（go template语法）的值默认是在 nginx/values.yaml 中定义的，只需要修改 nginx/values.yaml 的内容，也就完成了 templates 目录下 yaml 文件的配置。
比如在 deployment.yaml 中定义的容器镜像：
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"

cat nginx/values.yaml | grep repository
repository: nginx
#以上变量值是在 create chart 的时候就自动生成的默认值，你可以根据实际情况进行修改。
#### 打包和部署 Helm Chart
- 使用 helm lint 命令检查 chart 的依赖和模板配置是否正确。
- 使用 helm package 命令打包 chart，生成 .tgz 文件。
- 使用 helm install 命令部署 chart，可以选择使用 --dry-run 和 --debug 参数进行测试。
- 使用 helm install 命令正式部署 chart，可以指定命名空间和配置文件。
### Helm 常用命令
- helm create：在本地创建新的 chart；
- helm dependency：管理 chart 依赖；
- helm intall：安装 chart；
- helm lint：检查 chart 配置是否有误；
- helm list：列出所有 release；
- helm package：打包本地 chart；
- helm repo：列出、增加、更新、删除 chart 仓库；
- helm rollback：回滚 release 到历史版本；
- helm pull：拉取远程 chart 到本地；
- helm search：使用关键词搜索 chart；
- helm uninstall：卸载 release；
- helm upgrade：升级 release；

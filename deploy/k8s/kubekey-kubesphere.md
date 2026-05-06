# 使用kubeKey安装kubeSphere

## 下载安装工具kubeKey

### 下载脚本

```shell
wget https://get-kk.kubesphere.io
```

### 编辑脚本替换成代理URL

```
#!/bin/sh

# Copyright 2020 The KubeSphere Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ISLINUX=true
OSTYPE="linux"

if [ "x$(uname)" != "xLinux" ]; then
  echo ""
  echo 'Warning: Non-Linux operating systems are not supported! After downloading, please copy the tar.gz file to linux.'  
  ISLINUX=false
fi

# Fetch latest version
if [ "x${VERSION}" = "x" ]; then
  VERSION="$(curl -sL https://ghproxy.com/https://api.github.com/repos/kubesphere/kubekey/releases |
    grep -o 'download/v[0-9]*.[0-9]*.[0-9]*/' |
    sort --version-sort |
    tail -1 | awk -F'/' '{ print $2}')"
  VERSION="${VERSION##*/}"
fi

if [ -z "${ARCH}" ]; then
  case "$(uname -m)" in
  x86_64)
    ARCH=amd64
    ;;
  armv8*)
    ARCH=arm64
    ;;
  aarch64*)
    ARCH=arm64
    ;;
  *)
    echo "${ARCH}, isn't supported"
    exit 1
    ;;
  esac
fi

if [ "x${VERSION}" = "x" ]; then
  echo "Unable to get latest Kubekey version. Set VERSION env var and re-run. For example: export VERSION=v1.0.0"
  echo ""
  exit
fi

DOWNLOAD_URL="https://ghproxy.com/https://github.com/kubesphere/kubekey/releases/download/${VERSION}/kubekey-${VERSION}-${OSTYPE}-${ARCH}.tar.gz"
if [ "x${KKZONE}" = "xcn" ]; then
  DOWNLOAD_URL="https://ghproxy.com/https://kubernetes.pek3b.qingstor.com/kubekey/releases/download/${VERSION}/kubekey-${VERSION}-${OSTYPE}-${ARCH}.tar.gz"
fi

echo ""
echo "Downloading kubekey ${VERSION} from ${DOWNLOAD_URL} ..."
echo ""

curl -fsLO "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
  echo ""
  echo "Failed to download Kubekey ${VERSION} !"
  echo ""
  echo "Please verify the version you are trying to download."
  echo ""
  exit
fi

if [ ${ISLINUX} = true ]; then
  filename="kubekey-${VERSION}-${OSTYPE}-${ARCH}.tar.gz"
  ret='0'
  command -v tar >/dev/null 2>&1 || { ret='1'; }
  if [ "$ret" -eq 0 ]; then
    tar -xzf "${filename}"
  else
    echo "Kubekey ${VERSION} Download Complete!"
    echo ""
    echo "Try to unpack the ${filename} failed."
    echo "tar: command not found, please unpack the ${filename} manually."
    exit
  fi
fi

echo ""
echo "Kubekey ${VERSION} Download Complete!"
echo ""
```

### 执行脚本

```shell
export VERSION=v1.1.1 & sh downloadKubekey.sh
```

## 使用kk安装k8s集群

```shell
./kk create config --with-kubernetes v1.20.4 --with-kubesphere v3.1.1
```

- 手动下载

```shell
curl -L -o /opt/share/k8s/kubekey/kubekey/v1.20.4/amd64/cni-plugins-linux-amd64-v0.8.6.tgz https://ghproxy.com/https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v0.8.6.tgz
```

- 手动下载nfs 配置类文件

```shell
 curl -L -o addons.md https://ghproxy.com/https://raw.githubusercontent.com/kubesphere/kubekey/master/docs/addons.md
```

- 配置一下addons

```yaml
kind: Cluster
metadata:
  name: sample
spec:
  hosts:
  - {name: k8smaster, address: 192.168.122.110, internalAddress: 192.168.122.110, user: root, password: admin-123456}
  - {name: k8snode1, address: 192.168.122.111, internalAddress: 192.168.122.111, user: root, password: admin-123456}
  - {name: k8snode2, address: 192.168.122.112, internalAddress: 192.168.122.112, user: root, password: admin-123456}
  roleGroups:
    etcd:
    - k8smaster
    master:
    - k8smaster
    worker:
    - k8snode1
    - k8snode2
  controlPlaneEndpoint:
    domain: lb.kubesphere.local
    address: ""
    port: 6443
  kubernetes:
    version: v1.20.4
    imageRepo: kubesphere
    clusterName: cluster.local
  network:
    plugin: calico
    kubePodsCIDR: 10.233.64.0/18
    kubeServiceCIDR: 10.233.0.0/18
  registry:
    registryMirrors: []
    insecureRegistries: []
  addons:
  - name: nfs-client
    namespace: kube-system
    sources:
      chart:
        name: nfs-client-provisioner
        repo: https://charts.kubesphere.io/main
        valuesFile: custom-nfs-client-values.yaml  # or https://raw.githubusercontent.com/kubesphere/helm-charts/master/src/main/nfs-client-provisioner/values.yaml
        # values also supports parameter lists
        values:
        - storageClass.defaultClass=true
        - nfs.server=192.168.122.1
        - nfs.path=/home/nfs/k8s

---
apiVersion: installer.kubesphere.io/v1alpha1
kind: ClusterConfiguration
metadata:
  name: ks-installer
  namespace: kubesphere-system
  labels:
    version: v3.1.1
spec:
  persistence:
    storageClass: ""
  authentication:
    jwtSecret: ""
  zone: ""
  local_registry: ""
  etcd:
    monitoring: true
    endpointIps: localhost
    port: 2379
    tlsEnable: true
  common:
    redis:
      enabled: true
    redisVolumSize: 2Gi
    openldap:
      enabled: true
    openldapVolumeSize: 2Gi
    minioVolumeSize: 20Gi
    monitoring:
      endpoint: http://prometheus-operated.kubesphere-monitoring-system.svc:9090
    es:
      elasticsearchMasterVolumeSize: 4Gi
      elasticsearchDataVolumeSize: 20Gi
      logMaxAge: 7
      elkPrefix: logstash
      basicAuth:
        enabled: false
        username: ""
        password: ""
      externalElasticsearchUrl: ""
      externalElasticsearchPort: ""
  console:
    enableMultiLogin: true
    port: 30880
  alerting:
    enabled: true
    # thanosruler:
    #   replicas: 1
    #   resources: {}
  auditing:
    enabled: true
  devops:
    enabled: true
    jenkinsMemoryLim: 2Gi
    jenkinsMemoryReq: 1500Mi
    jenkinsVolumeSize: 8Gi
    jenkinsJavaOpts_Xms: 512m
    jenkinsJavaOpts_Xmx: 512m
    jenkinsJavaOpts_MaxRAM: 2g
  events:
    enabled: true
    ruler:
      enabled: true
      replicas: 2
  logging:
    enabled: true
    logsidecar:
      enabled: true
      replicas: 2
  metrics_server:
    enabled: true
  monitoring:
    storageClass: ""
    prometheusMemoryRequest: 400Mi
    prometheusVolumeSize: 20Gi
  multicluster:
    clusterRole: host
  network:
    networkpolicy:
      enabled: true
    ippool:
      type: none
    topology:
      type: none
  openpitrix:
    store:
      enabled: true
  servicemesh:
    enabled: true
  kubeedge:
    enabled: true
    cloudCore:
      nodeSelector: {"node-role.kubernetes.io/worker": ""}
      tolerations: []
      cloudhubPort: "10000"
      cloudhubQuicPort: "10001"
      cloudhubHttpsPort: "10002"
      cloudstreamPort: "10003"
      tunnelPort: "10004"
      cloudHub:
        advertiseAddress:
          - ""
        nodeLimit: "100"
      service:
        cloudhubNodePort: "30000"
        cloudhubQuicNodePort: "30001"
        cloudhubHttpsNodePort: "30002"
        cloudstreamNodePort: "30003"
        tunnelNodePort: "30004"
    edgeWatcher:
      nodeSelector: {"node-role.kubernetes.io/worker": ""}
      tolerations: []
      edgeWatcherAgent:
        nodeSelector: {"node-role.kubernetes.io/worker": ""}
        tolerations: []

```
- 部署k8s集群

```shell
./kk create cluster -f config-sample.yaml
```
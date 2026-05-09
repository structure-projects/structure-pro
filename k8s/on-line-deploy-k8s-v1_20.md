# k8s部署v1.20

| 主机名    | IP地址                    | 角色       | 系统      |
| --------- | ------------------------- | ---------- | --------- |
| k8sMaster | 192.168.122.114 | k8s-master | Centos7.6 |
| k8sNode1  | 192.168.122.115             | k8s-node   | Centos7.6 |
| k8sNode2  | 192.168.122.116           | k8s-node   | Centos7.6 |

## 环境配置

### 关闭防火墙

```shell
systemctl stop firewalld && systemctl disable firewalld
```

### 关闭SELinux

```shell
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
```

### 关闭swap分区

```shell
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### 加载内核模块

```shell
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
modprobe -- br_netfilter
EOF

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules
```

### 设置内核参数

```shell
cat << EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
net.ipv4.tcp_tw_recycle=0
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
EOF

sysctl -p /etc/sysctl.d/k8s.conf
```

## Docker 安装

### 卸载旧版

```shell
yum remove -y docker \
           docker-client \
           docker-client-latest \
           docker-common \
           docker-latest \
           docker-latest-logrotate \
           docker-logrotate \
           docker-selinux \
           docker-engine-selinux \
           docker-engine
```

### 设置安装源

```shell
yum -y install yum-utils 
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 安装Docker

```shell
yum makecache fast
yum list docker-ce --showduplicates | sort -r
yum -y install docker-ce-20.10.3
```

### 启动Docker设置开机自动启动

```shell
systemctl start docker & systemctl enable docker
```

### 修改docker仓库配置

```shell
sed -i "13i ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT" /usr/lib/systemd/system/docker.service

tee /etc/docker/daemon.json <<-'EOF'
{
 "insecure-registries":["https://10.16.105.194"],
  "registry-mirrors": ["https://bk6kzfqm.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

systemctl daemon-reload
systemctl restart docker
```

## 部署k8s

### 设置镜像源

``` shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum makecache fast
```

### 安装k8s软件

```shell
yum install -y kubelet-1.20.4-0 kubeadm-1.20.4-0 kubectl-1.20.4-0

systemctl enable --now kubelet
```

### 拉取所需镜像

1. 查看镜像

```shell
 kubeadm config images list --kubernetes-version v1.20.4
```

2. 编写拉取脚本

```shell
vim get-k8s-images.sh
```

```sh
#!/bin/bash
# Script For Quick Pull K8S Docker Images

KUBE_VERSION=v1.20.4
PAUSE_VERSION=3.2
CORE_DNS_VERSION=1.7.0
ETCD_VERSION=3.4.13-0

# pull kubernetes images from hub.docker.com
docker pull kubeimage/kube-proxy-amd64:$KUBE_VERSION
docker pull kubeimage/kube-controller-manager-amd64:$KUBE_VERSION
docker pull kubeimage/kube-apiserver-amd64:$KUBE_VERSION
docker pull kubeimage/kube-scheduler-amd64:$KUBE_VERSION
# pull aliyuncs mirror docker images
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$CORE_DNS_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION

# retag to k8s.gcr.io prefix
docker tag kubeimage/kube-proxy-amd64:$KUBE_VERSION  k8s.gcr.io/kube-proxy:$KUBE_VERSION
docker tag kubeimage/kube-controller-manager-amd64:$KUBE_VERSION k8s.gcr.io/kube-controller-manager:$KUBE_VERSION
docker tag kubeimage/kube-apiserver-amd64:$KUBE_VERSION k8s.gcr.io/kube-apiserver:$KUBE_VERSION
docker tag kubeimage/kube-scheduler-amd64:$KUBE_VERSION k8s.gcr.io/kube-scheduler:$KUBE_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION k8s.gcr.io/pause:$PAUSE_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$CORE_DNS_VERSION k8s.gcr.io/coredns:$CORE_DNS_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION k8s.gcr.io/etcd:$ETCD_VERSION

# untag origin tag, the images won't be delete.
docker rmi kubeimage/kube-proxy-amd64:$KUBE_VERSION
docker rmi kubeimage/kube-controller-manager-amd64:$KUBE_VERSION
docker rmi kubeimage/kube-apiserver-amd64:$KUBE_VERSION
docker rmi kubeimage/kube-scheduler-amd64:$KUBE_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$CORE_DNS_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION
```

3. 导出镜像

   ```shell
   docker save $(docker images | grep -v REPOSITORY | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o k8s-1.20.4-images.tar
   ```

4. 导入镜像

```shell
docker image load -i k8s-1.20.4-images.tar
```

### 初始化集群

```shell
kubeadm init  --kubernetes-version=v1.20.4 --apiserver-advertise-address=192.168.122.114 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.1.0.0/16
```
### 加入集群node节点

这里省略代码，基本就是将上面初始化集群后大打印的命令复制到node节点中进行加入集群


### 安装网络插件（二选一）

### 安装flannel网络
简单部署推荐使用这个网络插件

```shell
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### 安装Calico网络插件
如果后续有更多组件推荐使用这个网络插件
```shell
curl  https://docs.projectcalico.org/v3.15/manifests/calico.yaml -O

kubectl apply -f calico.yaml

```

### 扩展主节点
如果你有多个主节点要进行高可用搭建时通过该部署扩展master节点，如果没有可以跳过

- 生成加入token

```shell
kubeadm token create --print-join-command
```

- 生成key

```shell
kubeadm init phase upload-certs --upload-certs
```

- 添加配置

```shell
kubectl -n kube-system edit cm kubeadm-config
```

```yaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        authorization-mode: Node,RBAC
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controllerManager: {}
    dns:
      type: CoreDNS
    etcd:
      local:
        dataDir: /var/lib/etcd
    imageRepository: k8s.gcr.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.20.4
    controlPlaneEndpoint: 192.168.122.114:6443 # 在此处添加主节点
    networking:
      dnsDomain: cluster.local
      podSubnet: 10.244.0.0/16
      serviceSubnet: 10.1.0.0/16
    scheduler: {}
  ClusterStatus: |
    apiEndpoints:
      k8s-master1:
        advertiseAddress: 192.168.122.113
        bindPort: 6443
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterStatus
kind: ConfigMap
metadata:
  creationTimestamp: "2022-12-16T06:24:45Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:ClusterStatus: {}
    manager: kubeadm
    operation: Update
    time: "2022-12-16T06:24:45Z"
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        f:ClusterConfiguration: {}
    manager: kubectl-edit
    operation: Update
    time: "2022-12-16T06:50:42Z"
  name: kubeadm-config
  namespace: kube-system
  resourceVersion: "3100"
  uid: 7fdba827-41a5-4499-aeb4-b74502c69aac
```



### kub-proxy开启ipvs

```shell
kubectl get configmap kube-proxy -n kube-system -o yaml > kube-proxy-configmap.yaml
sed -i 's/mode: ""/mode: "ipvs"/' kube-proxy-configmap.yaml
kubectl apply -f kube-proxy-configmap.yaml
rm -f kube-proxy-configmap.yaml
kubectl get pod -n kube-system | grep kube-proxy | awk '{system("kubectl delete pod "$1" -n kube-system")}' 
```

### 部署 kubernetes-dashboard
```shell
# wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
cat > recommended.yaml<<-EOF
# Copyright 2017 The Kubernetes Authors.
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

apiVersion: v1
kind: Namespace
metadata:
  name: kubernetes-dashboard

---

apiVersion: v1
kind: ServiceAccount
metadata:::
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard

---

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort 
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30008 
  selector:
    k8s-app: kubernetes-dashboard

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-certs
  namespace: kubernetes-dashboard
type: Opaque

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-csrf
  namespace: kubernetes-dashboard
type: Opaque
data:
  csrf: ""

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-key-holder
  namespace: kubernetes-dashboard
type: Opaque

---

kind: ConfigMap
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-settings
  namespace: kubernetes-dashboard

---

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
rules:
  # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
  - apiGroups: [""]
    resources: ["secrets"]
    resourceNames: ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs", "kubernetes-dashboard-csrf"]
    verbs: ["get", "update", "delete"]
    # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
  - apiGroups: [""]
    resources: ["configmaps"]
    resourceNames: ["kubernetes-dashboard-settings"]
    verbs: ["get", "update"]
    # Allow Dashboard to get metrics.
  - apiGroups: [""]
    resources: ["services"]
    resourceNames: ["heapster", "dashboard-metrics-scraper"]
    verbs: ["proxy"]
  - apiGroups: [""]
    resources: ["services/proxy"]
    resourceNames: ["heapster", "http:heapster:", "https:heapster:", "dashboard-metrics-scraper", "http:dashboard-metrics-scraper"]
    verbs: ["get"]

---

kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
rules:
  # Allow Metrics Scraper to get metrics from the Metrics server
  - apiGroups: ["metrics.k8s.io"]
    resources: ["pods", "nodes"]
    verbs: ["get", "list", "watch"]

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kubernetes-dashboard
subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubernetes-dashboard
subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard

---

kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: kubernetes-dashboard
  template:
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
    spec:
      containers:
        - name: kubernetes-dashboard
          image: kubernetesui/dashboard:v2.0.0-beta1
          imagePullPolicy: Always
          ports:
            - containerPort: 8443
              protocol: TCP
          args:
            - --auto-generate-certificates
            - --namespace=kubernetes-dashboard
            # Uncomment the following line to manually specify Kubernetes API server Host
            # If not specified, Dashboard will attempt to auto discover the API server and connect
            # to it. Uncomment only if the default does not work.
            # - --apiserver-host=http://my-address:port
          volumeMounts:
            - name: kubernetes-dashboard-certs
              mountPath: /certs
              # Create on-disk volume to store exec logs
            - mountPath: /tmp
              name: tmp-volume
          livenessProbe:
            httpGet:
              scheme: HTTPS
              path: /
              port: 8443
            initialDelaySeconds: 30
            timeoutSeconds: 30
      volumes:
        - name: kubernetes-dashboard-certs
          secret:
            secretName: kubernetes-dashboard-certs
        - name: tmp-volume
          emptyDir: {}
      serviceAccountName: kubernetes-dashboard
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule

---

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-metrics-scraper
  name: dashboard-metrics-scraper
  namespace: kubernetes-dashboard
spec:
  ports:
    - port: 8000
      targetPort: 8000
  selector:
    k8s-app: kubernetes-metrics-scraper

---

kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: kubernetes-metrics-scraper
  name: kubernetes-metrics-scraper
  namespace: kubernetes-dashboard
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: kubernetes-metrics-scraper
  template:
    metadata:
      labels:
        k8s-app: kubernetes-metrics-scraper
    spec:
      containers:
        - name: kubernetes-metrics-scraper
          image: kubernetesui/metrics-scraper:v1.0.0
          ports:
            - containerPort: 8000
              protocol: TCP
          livenessProbe:
            httpGet:
              scheme: HTTP
              path: /
              port: 8000
            initialDelaySeconds: 30
            timeoutSeconds: 30
      serviceAccountName: kubernetes-dashboard
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
EOF
```

### 修改配置增加访问端口

```shell
vi recommended.yaml
```

```shell
#增加直接访问端口
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort #增加
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30008 #增加
  selector:
    k8s-app: kubernetes-dashboard
```

### 创建证书

```shell
mkdir dashboard-certs
cd dashboard-certs/
#创建命名空间
kubectl create namespace kubernetes-dashboard
# 创建私钥key文件
openssl genrsa -out dashboard.key 2048
#证书请求
openssl req -days 36000 -new -out dashboard.csr -key dashboard.key -subj '/CN=dashboard-cert'
#自签证书
openssl x509 -req -in dashboard.csr -signkey dashboard.key -out dashboard.crt
#创建kubernetes-dashboard-certs对象
kubectl create secret generic kubernetes-dashboard-certs --from-file=dashboard.key --from-file=dashboard.crt -n kubernetes-dashboard
```

### 创建dashboard管理员

```shell
cat > dashboard-admin.yaml<<-EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: dashboard-admin
  namespace: kubernetes-dashboard
EOF
#保存退出后执行
kubectl create -f dashboard-admin.yaml
```

### 为用户分配权限

```shell
cat > dashboard-admin-bind-cluster-role.yaml<<-EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dashboard-admin-bind-cluster-role
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dashboard-admin
  namespace: kubernetes-dashboard
EOF
#保存退出后执行
kubectl create -f dashboard-admin-bind-cluster-role.yaml
```

### 安装dashboard

``` shell
#安装
kubectl create -f  ./recommended.yaml

#检查结果
kubectl get pods -A  -o wide
```

### 查看用户token

```shell
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep dashboard-admin | awk '{print $1}')
```

### 安装部署 metrics-server 插件

#### 下载metrics-server文件

```shell
mkdir metrics-server
cd metrics-server/
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml
cp components.yaml{,.bak}
```

#### 修改配置

```shell
cat > components.yaml <<-EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    k8s-app: metrics-server
    rbac.authorization.k8s.io/aggregate-to-admin: "true"
    rbac.authorization.k8s.io/aggregate-to-edit: "true"
    rbac.authorization.k8s.io/aggregate-to-view: "true"
  name: system:aggregated-metrics-reader
rules:
- apiGroups:
  - metrics.k8s.io
  resources:
  - pods
  - nodes
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    k8s-app: metrics-server
  name: system:metrics-server
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - nodes
  - nodes/stats
  - namespaces
  - configmaps
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server-auth-reader
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: extension-apiserver-authentication-reader
subjects:
- kind: ServiceAccount
  name: metrics-server
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server:system:auth-delegator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: metrics-server
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: metrics-server
  name: system:metrics-server
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:metrics-server
subjects:
- kind: ServiceAccount
  name: metrics-server
  namespace: kube-system
---
apiVersion: v1
kind: Service
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
spec:
  ports:
  - name: https
    port: 443
    protocol: TCP
    targetPort: https
  selector:
    k8s-app: metrics-server
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
spec:
  selector:
    matchLabels:
      k8s-app: metrics-server
  strategy:
    rollingUpdate:
      maxUnavailable: 0
  template:
    metadata:
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=4443
        - --kubelet-insecure-tls  #需要在配置文件中添加这一条，不验证客户端证书
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        image: phperall/metrics-server:v0.4.1 #镜像需要手动拉取一下，直接文件拉取可能会失败
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /livez
            port: https
            scheme: HTTPS
          periodSeconds: 10
        name: metrics-server
        ports:
        - containerPort: 4443
          name: https
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /readyz
            port: https
            scheme: HTTPS
          periodSeconds: 10
        securityContext:
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1000
        volumeMounts:
        - mountPath: /tmp
          name: tmp-dir
      nodeSelector:
        kubernetes.io/os: linux
      priorityClassName: system-cluster-critical
      serviceAccountName: metrics-server
      volumes:
      - emptyDir: {}
        name: tmp-dir
---
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  labels:
    k8s-app: metrics-server
  name: v1beta1.metrics.k8s.io
spec:
  group: metrics.k8s.io
  groupPriorityMinimum: 100
  insecureSkipTLSVerify: true
  service:
    name: metrics-server
    namespace: kube-system
  version: v1beta1
  versionPriority: 100
EOF
```

#### 部署

```shell
kubectl apply -f components.yaml
```

### 卸载k8s 

#### 删除所有安装的docker文件包

```shell
yum -y remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine
 
rm -rf /etc/systemd/system/docker.service.d
rm -rf /var/lib/docker
rm -rf /var/run/docker
```

#### 停止相关服务

```shell
systemctl stop kubelet 
systemctl stop etcd 
systemctl stop docker
```

#### 使用kubeadm卸载k8s

```shell
kubeadm reset -f
```

#### 删除k8s相关目录

```shell
modprobe -r ipip
lsmod
rm -rf ~/.kube/
rm -rf /etc/kubernetes/
rm -rf /etc/systemd/system/kubelet.service.d
rm -rf /etc/systemd/system/kubelet.service
rm -rf /usr/bin/kube*
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/etcd
rm -rf /var/etcd

```

#### 卸载k8s相关程序

```shell
yum -y remove kube*
```


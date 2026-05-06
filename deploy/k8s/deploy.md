# K8s搭建文档v1.8

## 准备工作

- 关闭防火墙

```shell
systemctl stop firewalld
systemctl disable firewalld
```

- 关闭selinux

```shell
# 永久关闭
sed -i 's/enforcing/disabled/' /etc/selinux/config  
# 临时关闭
setenforce 0  
```

- 关闭swap

```shell
# 临时
swapoff -a 
# 永久关闭
sed -ri 's/.*swap.*/#&/' /etc/fstab
```

- 设置hostname

```shell
hostnamectl set-hostname k8smaster
hostnamectl set-hostname k8snode1
hostnamectl set-hostname k8snode2
```

- 添加host

```shell
cat >> /etc/hosts << EOF
192.168.153.201 k8smaster
192.168.153.202 k8snode1
192.168.153.203 k8snode2
EOF
```

- 将桥接的IPv4流量传递到iptables的链

```shell
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
# 生效
sysctl --system  
```

- 时间同步

```shell
yum install ntpdate -y
ntpdate time.windows.com
```

## 安装Docker

- 首先配置一下Docker的阿里yum源

```shell
cat >/etc/yum.repos.d/docker.repo<<EOF
[docker-ce-edge]
name=Docker CE Edge - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/\$basearch/edge
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
```

- 然后yum方式安装docker

```shell
# yum安装
yum -y install docker-ce

# 查看docker版本
docker --version  

# 启动docker
systemctl enable docker
systemctl start docker
```

- 配置docker的镜像源

```shell
cat >> /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}
EOF
```

- 重启docker

```shell
systemctl reload docker
systemctl restart docker
```

## 安装kubeadm，kubelet和kubectl

- 添加kubernetes软件源

```shell
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

- 安装kubeadm，kubelet和kubectl

```shell
# 安装kubelet、kubeadm、kubectl，同时指定版本
yum install -y kubelet-1.18.0 kubeadm-1.18.0 kubectl-1.18.0
# 设置开机启动
systemctl enable kubelet
```

- 部署Kubernetes Master【master节点】

```shell
kubeadm init --apiserver-advertise-address=192.168.153.201 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.18.0 --service-cidr=10.96.0.0/12  --pod-network-cidr=10.244.0.0/16
```

- 加入Kubernetes Node【Slave节点】

```shell
kubeadm join 192.168.153.201:6443 --token e4f6ri.56mfq1ep53lgl0zv     --discovery-token-ca-cert-hash sha256:f437af9c658650c6ba036e79acd0f1ba0a51f0ed98fa32f254f0fc5e6b1e06b0
```

## 部署CNI网络插件

```shell
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl apply -f calico.yaml
```

## 安装Calico网络插件

```shell
curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml
```


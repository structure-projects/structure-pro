# docker-swarm 集群高可用部署

## 环境基础信息

| 主机名       | IP地址                    | 角色                    | 系统      |
| ------------ | ------------------------- | ----------------------- | --------- |
| docerkMaster | 172.16.48.1			   |manager 			 | Centos7.6 |
| dockerNode1  | 172.16.48.135             | worker | Centos7.6 |
| dockerNode2  | 172.16.48.136             | worker        | Centos7.6 |

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
yum remove docker \
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
yum install yum-utils -y
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

## 搭建集群

### 初始化集群

在dockerMasert上初始化集群主节点

```shell
docker swarm init --advertise-addr 172.16.48.1
```

### 加入集群

在node节点上运行如下命令加入集群

```shell
docker swarm join --token SWMTKN-1-2l0hsaj0d300919595jjh7wud8tvd9r873ahias5udmc4o5hhi-5cbexlalurwnxyovpdpkdfbit 172.16.48.1:2377
```

### 测试集群状态

```shell
docker node ls
```

### 安装管理页码

```yaml
version: '3.2'
services:
  agent:
    image: portainer/agent:2.11.1
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
    networks:
      - agent_network
    deploy:
      mode: global
      placement:
        constraints: [node.platform.os == linux]

  portainer:
    image: portainer/portainer-ce:2.11.1
    command: -H tcp://tasks.agent:9001 --tlsskipverify
    ports:
      - "9443:9443"
      - "9000:9000"
      - "8000:8000"
    volumes:
      - ./portainer_data:/data
    networks:
      - agent_network
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == manager]

networks:
  agent_network:
    driver: overlay
    attachable: true

```

## 特殊注意

如果在无网络环境下建议手动加载镜像

有网络情况下也建议手动加载镜像部署时会非常流畅避免等待拉取镜像时间过长

#### 手动加载镜像

找一台能拉取镜像的机器如果已经有镜像包可以忽略次操作

```sh
#!/bin/bash

docker pull portainer/portainer-ce:2.11.1
docker pull portainer/agent:2.11.1

```

保存镜像

```shell
docker save $(docker images | grep -v REPOSITORY | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o portainer-images.tar
```

导入镜像

```shell
docker image load -i  portainer-images.tar
```


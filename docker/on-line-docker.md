## 在线部署Docker

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

## 设置工具

```shell
yum install -y vim  nfs-utils 
```

下载docker-compose

```shell
curl -L https://get.daocloud.io/docker/compose/releases/download/v2.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

添加执行权限

```shell
chmod +x /usr/local/bin/docker-compose
```
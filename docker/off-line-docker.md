# 离线安装docker

## 下载离线安装包

https://download.docker.com/linux/static/stable/x86_64/

选择docker-20.10.3版本 
https://download.docker.com/linux/static/stable/x86_64/docker-20.10.3.tgz

## 解压安装包

```shell
tar -zxvf docker-20.10.3.tgz
```

## 将解压后的docker文件拷贝到/usr/bin

```shell
cp -p docker/* /usr/bin
```

## 将docker注册为系统服务

```shell
vi /usr/lib/systemd/system/docker.service
```

```ini
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
#Requires=docker.socket containerd.service
  
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd --selinux-enabled=false
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
  
[Install]
WantedBy=multi-user.target
```

### 设置开机启动

```shell
 systemctl daemon-reload 
 systemctl start docker
 systemctl enable docker.service # 设置开机自启动
```


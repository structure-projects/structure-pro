# NFS在线安装

## 环境基础信息

| 主机名       | IP地址                    | 角色                    | 系统      |
| ------------ | ------------------------- | ----------------------- | --------- |
| docerkMaster | 172.16.48.1			   |server 			 | Centos7.6 |
| dockerNode1  | 172.16.48.135             | client | Centos7.6 |
| dockerNode2  | 172.16.48.136             | client | Centos7.6 |

## 服务端搭建

### 服务端安装 nfs,rpc 服务
```shell
yum install -y nfs-utils rpcbind && yum install -y nfs-utils
```

### 配置 nfs 服务

#### 创建共享目录

``` shell
mkdir -p /home/share
```

#### 修改nfs配置文件

```shell
vim /etc/exports
```

```
/home/share/  *(rw,no_root_squash,no_all_squash,sync)
```

### 查看服务端是否正常加载/etc/exports配置文件

```shell
exportfs -r
showmount -e localhost
```

### 启动RPC,nfs服务
服务端需要按照顺序启动，应该先启动rpcbind 在启动nfs
```shell
systemctl start rpcbind && systemctl start nfs
```

## 客户端搭建

### 安装nfs客户端nfs-utils

```shell
 yum install nfs-utils vim -y
```

### 查看服务端可共享的目录

```shell
showmount -e 192.168.122.1
```

### 挂载服务端共享目录

```shell
mkdir -p /opt/share && mount -t nfs 192.168.122.1:/home/share /opt/share/ -o nolock,nfsvers=3,vers=3
```

### 设置开机自动挂载

将挂载命令添加到启动文件中

```shelli
vim /etc/fstab
```

```shell
192.168.122.1:/home/share /opt/share/ nfs defaults        0 0
```


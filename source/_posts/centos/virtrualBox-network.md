---
title: VirtrualBox 配置网络
date: 2016/9/18
categories: centos
---

## VirtrualBox安装Centos6.8 minimal
VirtrualBox新建个虚拟机配置好内存以及硬盘大小，安装即可；

网络方式是 NAT(默认)和桥接方式来实现，最好在安装前设置好，NAT主要是连外网，桥接可通过局域网IP访问；
{% qnimg virtrualbox/1.png %}
{% qnimg virtrualbox/2.png %}
设置-网络-网卡1（NAT）默认已经设置好了，再点开 网卡2，连接方式选择 桥接网卡；

## 配置局域网IP
### 修改ip地址
进入文件夹 `cd /etc/sysconfig/newwork-scripts/` 可以看到两个eth0(NAT) eth1(桥接)
{% qnimg virtrualbox/3.png %}
把eth0的ONBOOT设置成yes，就是开机启动的意思
{% qnimg virtrualbox/4.png %}
桥接设置如下：
```shell
DEVICE="eth1"
BOOTPROTO="static"   #这里改为使用静态ip
ONBOOT="yes"   #设置为自动启动
IPADDR=192.168.231.200     #设置该虚拟机的ip地址，要与宿主机在一个网段，但是不能重名
NETMASK=255.255.255.0      #设置子网掩码
GATEWAY=192.168.231.1   #设置网关
```

{% qnimg virtrualbox/5.png %}
### 修改网关
使用命令：`vi /etc/sysconfig/network` 修改该文件内容如下：
```shell
NETWORKING=yes
HOSTNAME=localhost.localdomain
GATEWAY=192.168.231.1   # 这里设置网关，也就是那个虚拟网卡的ip
```
### 修改DNS
使用命令：`vi /ect/resolv.conf`  修改该文件内容如下：
```shell
nameserver 192.168.231.1 # 增加一个域名服务器
```

### 测试网络
重启下网络服务 `service network restart`

测试能否访问外网：
{% qnimg virtrualbox/6.png %}
能否ping通192.168.231.200
{% qnimg virtrualbox/7.png %}

OK,网络设置好了！
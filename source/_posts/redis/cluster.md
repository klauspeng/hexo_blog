---
title: Redis集群
date: 2018/8/21
categories: redis
---

### 参考文章
[Redis集群](https://www.cnblogs.com/cjsblog/p/9048545.html)  
[为什么redis哨兵集群只有2个节点无法正常工作？](https://blog.csdn.net/qq_25868207/article/details/79147469)

### 为什么最少三个master节点？
因为投票机制  
集群中节点的fail是通过集群中超过半数的节点检测失效时才生效  
例如只有两个节点,挂掉一个,剩下一个投票是不会超过50%的,所以最少要三个节点

### 搭建
需编译安装！！！

```shell
yum install ruby
yum install rubygems
gem install redis
```
如提示Ruby版本需升级：
```shell
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm list known
rvm install 2.4.1
```

用create-cluster创建集群：  

1. 进入utils/create-cluster，可以看README
2. `create-cluster start`
3. `create-cluster create`

```
# ./create-cluster create
>>> Creating cluster
>>> Performing hash slots allocation on 8 nodes...
Using 4 masters:
127.0.0.1:30001
127.0.0.1:30002
127.0.0.1:30003
127.0.0.1:30004
Adding replica 127.0.0.1:30005 to 127.0.0.1:30001
Adding replica 127.0.0.1:30006 to 127.0.0.1:30002
Adding replica 127.0.0.1:30007 to 127.0.0.1:30003
Adding replica 127.0.0.1:30008 to 127.0.0.1:30004
M: 684c87a4466ad65feb91964556d842c6f002faa3 127.0.0.1:30001
   slots:0-4095 (4096 slots) master
M: 3da9d9481730d373f08627cab3c273fe616e7a0a 127.0.0.1:30002
   slots:4096-8191 (4096 slots) master
M: ea8ce815984589a12c5d183de6efd005e080bad4 127.0.0.1:30003
   slots:8192-12287 (4096 slots) master
M: 1dc55a732861509924b08064bd3884d12d7529e9 127.0.0.1:30004
   slots:12288-16383 (4096 slots) master
S: 7adb84ac950e3e434c4ca240c32b986199bfdc50 127.0.0.1:30005
   replicates 684c87a4466ad65feb91964556d842c6f002faa3
S: f557e2a9a58b5b56c697016042cdfaaa78c39af1 127.0.0.1:30006
   replicates 3da9d9481730d373f08627cab3c273fe616e7a0a
S: eab252c2e051ce599bb90bcabcc4c0cca883c6ec 127.0.0.1:30007
   replicates ea8ce815984589a12c5d183de6efd005e080bad4
S: 494dc2ace152be4e159d229b2cbe5daa1f03a7d4 127.0.0.1:30008
   replicates 1dc55a732861509924b08064bd3884d12d7529e9
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join..
>>> Performing Cluster Check (using node 127.0.0.1:30001)
M: 684c87a4466ad65feb91964556d842c6f002faa3 127.0.0.1:30001
   slots:0-4095 (4096 slots) master
   1 additional replica(s)
S: eab252c2e051ce599bb90bcabcc4c0cca883c6ec 127.0.0.1:30007
   slots: (0 slots) slave
   replicates ea8ce815984589a12c5d183de6efd005e080bad4
S: 7adb84ac950e3e434c4ca240c32b986199bfdc50 127.0.0.1:30005
   slots: (0 slots) slave
   replicates 684c87a4466ad65feb91964556d842c6f002faa3
M: 1dc55a732861509924b08064bd3884d12d7529e9 127.0.0.1:30004
   slots:12288-16383 (4096 slots) master
   1 additional replica(s)
M: ea8ce815984589a12c5d183de6efd005e080bad4 127.0.0.1:30003
   slots:8192-12287 (4096 slots) master
   1 additional replica(s)
M: 3da9d9481730d373f08627cab3c273fe616e7a0a 127.0.0.1:30002
   slots:4096-8191 (4096 slots) master
   1 additional replica(s)
S: f557e2a9a58b5b56c697016042cdfaaa78c39af1 127.0.0.1:30006
   slots: (0 slots) slave
   replicates 3da9d9481730d373f08627cab3c273fe616e7a0a
S: 494dc2ace152be4e159d229b2cbe5daa1f03a7d4 127.0.0.1:30008
   slots: (0 slots) slave
   replicates 1dc55a732861509924b08064bd3884d12d7529e9
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

集群（4主4从）效果如下：
```
127.0.0.1:30001> cluster nodes
3da9d9481730d373f08627cab3c273fe616e7a0a 127.0.0.1:30002 master - 0 1534843625613 2 connected 4096-8191
494dc2ace152be4e159d229b2cbe5daa1f03a7d4 127.0.0.1:30008 master - 0 1534843625613 9 connected 12288-16383
7adb84ac950e3e434c4ca240c32b986199bfdc50 127.0.0.1:30005 slave 684c87a4466ad65feb91964556d842c6f002faa3 0 1534843625613 5 connected
eab252c2e051ce599bb90bcabcc4c0cca883c6ec 127.0.0.1:30007 slave ea8ce815984589a12c5d183de6efd005e080bad4 0 1534843625613 7 connected
ea8ce815984589a12c5d183de6efd005e080bad4 127.0.0.1:30003 master - 0 1534843625310 3 connected 8192-12287
1dc55a732861509924b08064bd3884d12d7529e9 127.0.0.1:30004 slave 494dc2ace152be4e159d229b2cbe5daa1f03a7d4 0 1534843625613 9 connected
f557e2a9a58b5b56c697016042cdfaaa78c39af1 127.0.0.1:30006 slave 3da9d9481730d373f08627cab3c273fe616e7a0a 0 1534843625512 6 connected
684c87a4466ad65feb91964556d842c6f002faa3 127.0.0.1:30001 myself,master - 0 0 1 connected 0-4095
```

### PHP连接集群
```php
$redis = new \RedisCluster(NULL, ['127.0.0.1:30001']);
// 管道技术
$pipe = $redis->multi(\Redis::PIPELINE);
for ($i = 0; $i < 3; $i++) {
    $key = "key::{$i}";
    dump($pipe->set($key, str_pad($i, 2, '0', 0)));
    echo PHP_EOL;
    dump($pipe->get($key));
    echo PHP_EOL;
}
$result = $pipe->exec();
dump($result);
```

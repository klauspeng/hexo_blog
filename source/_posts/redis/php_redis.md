---
title: Redis学习笔记
date: 2017/4/18
categories: redis
---
## window下安装 
[github地址](https://github.com/MSOpenTech/redis/releases)

> 命令不区分大小写，但key区分大小写！

## [中文手册](http://www.cnblogs.com/zcy_soft/archive/2012/09/21/2697006.html#key_del)

## windows注册成服务
> redis-server.exe --service-install redis.6380.conf --service-name redis6380 --port 6380


##　客户端按端口连接
>  redis-cli -h host -p port -a password  
>  redis-cli.exe -p 6380

## 常用命令
- 删除key:del key_name
- 返回序列化值：dump key_name
- 检测key是否存在：exists key_name
- 设置过期时间：expire key_name time_in_seconds
- 以unix时间戳格式设置过期时间：expireat key_name time_in_unix_timestamp
- 查找所有符合给定模式pattern的key：keys pattern
- 将当前数据库的 key 移动到给定的数据库db当中:move key_name destination_database
- 移除给定 key 的过期时间，使得 key 永不过期:persist key_name
- 以毫秒为单位返回 key 的剩余的过期时间:pttl key_name
- 以秒为单位返回 key 的剩余过期时间:ttl key_name
- 从当前数据库中随机返回一个 key:randomkey 
- 修改 key 的名称:rename old_key_name new_key_name
- 在新的 key 不存在时修改 key 的名称:renamenx old_key_name new_key_name
- 返回 key 所储存的值的类型:type key_name

## 数据类型
### 字符串String
1. 二进制安全的，string可以包含任何数据。比如jpg图片或者序列化的对象 。
2. 一个键最大能存储512MB

#### 命令
1. `set key value --设置指定 key 的值。`
2. `get key --获取指定 key 的值。`
3. getrange key start end --返回 key 中字符串值的子字符。
4. getset key value--将给定 key 的值设为 value ，并返回 key 的旧值(old value)。
5. getbit key offset--对 key 所储存的字符串值，获取指定偏移量上的位(bit)。
6. mget key1 [key2..]--获取所有(一个或多个)给定 key 的值。
7. setbit key offset value--对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)。
8. setex key seconds value--将值 value 关联到 key ，并将 key 的过期时间设为 seconds (以秒为单位)。
9. setnx key value--只有在 key 不存在时设置 key 的值。
10.  setrange key offset value--用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始。
11.  strlen key--返回 key 所储存的字符串值的长度。
12.  mset key value [key value .--.]同时设置一或多个 key-value 对。
13.  msetnx key value [key value ...] --同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。
14.  psetex key milliseconds value--这个命令和 setex 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 setex 命令那样，秒为单位。
15.  incr key--将 key 中储存的数字值增一。
16.  incrby key increment--将 key 所储存的值加上给定的增量值（increment） 。
17.  incrbyfloat key increment--将 key 所储存的值加上给定的浮点增量值（increment） 。
18.  decr key--将 key 中储存的数字值减一。
19.  decrby key decrement--key 所储存的值减去给定的减量值（decrement） 。
20.  append key value--如果 key 已经存在并且是一个字符串， append 命令将 value 追加到 key 原来的值的末尾。

### Hash（哈希）
1. Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。
2. 每个 hash 可以存储 2^32 -1 键值对（40多亿）。
3. 命令如下：  
![redis hash](http://ww1.sinaimg.cn/large/80eaa069ly1feqv33tysbj20fn07vdge.jpg)

### List（列表-有序可重复）
1. 是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。
2. 列表最多可存储 232 - 1 元素 (4294967295, 每个列表可存储40多亿)。
3. 命令如下：  
![redis list](http://ww1.sinaimg.cn/large/80eaa069ly1feqvosohzij20g008nq3d.jpg)

### Set（集合-无序不可重复）
1. 是string类型的无序集合。
2. 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。
3. sadd添加一个string元素到,key对应的set集合中，成功返回1,如果元素已经在集合中返回0,key对应的set不存在返回错误。
4. 命令如下：  
![redis set](http://ww1.sinaimg.cn/large/80eaa069ly1feqvtxt7boj20gu0a8q3c.jpg) 

### zset(sorted set：有序集合-有序不可重复)
1. zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。
2. 不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。
3. zset的成员是唯一的,但分数(score)却可以重复。
4. zadd 添加元素到集合，元素在集合中存在则更新对应score
5. 命令如下：    
![redis zset](http://ww1.sinaimg.cn/large/80eaa069ly1feqw0bhlqrj20f70co3yz.jpg)


## 主从同步
[参考文章](http://www.cnblogs.com/liuling/p/2014-4-19-02.html)  
启动主从服务后，直接在从客户端输入命令`slaveof 192.168.0.100 6379`  (映射到主服务器上)  

## phpredis扩展常用命令
### 连接
```php
$redis = new redis();  
$result = $redis->connect('127.0.0.1', 6379);  
var_dump($result); //结果：bool(true)  
```
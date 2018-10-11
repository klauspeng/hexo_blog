---
title: mysql表分区
date: 2018/10/11
categories: mysql
---

对mysql表分区的认识与理解。
<!-- more -->

## 定义
> 表分区，是指根据一定规则，将数据库中的一张表分解成多个更小的，容易管理的部分。从逻辑上看，**只有一张表**，但是底层却是由**多个物理分区**组成。

## 注意点
1. 所有的底层表都必须使用相同的存储引擎
2. 一个表最多只能有1024个分区
3. 如果分区字段中有主键或者唯一索引的列，那么多有主键列和唯一索引列都必须包含进来
4. 分区表中无法使用外键约束
5. MySQL的分区适用于一个表的所有数据和索引

## 使用场景
A. 表非常大以至于无法全部都放在内存中，或者只在表的最后部分有热点数据，其他都是历史数据
B. 分区表的数据更容易维护，如：想批量删除大量数据可以使用清除整个分区的方式。另外，还可以对一个独立分区进行优化、检查、修复等操作
C. 分区表的数据可以分布在不同的物理设备上，从而高效地利用多个硬件设备
D. 可以使用分区表来避免某些特殊的瓶颈，如：innodb的单个索引的互斥访问，ext3文件系统的inode锁竞争等
E. 如果需要，还可以备份和恢复独立的分区，这在非常大的数据集的场景下效果非常好
F. 优化查询，在where字句中包含分区列时，可以只使用必要的分区来提高查询效率，同时在涉及sum()和count()这类聚合函数的查询时，可以在每个分区上面并行处理，最终只需要汇总所有分区得到的结果。

## 原理
> 分区表是由多个相关的底层表实现，这些底层表也是由句柄对象表示，所以我们也可以直接访问各个分区，存储引擎管理分区的各个底层表和管理普通表一样（所有的底层表都必须使用相同的存储引擎），分区表的索引只是在各个底层表上各自加上一个相同的索引，从存储引擎的角度来看，底层表和一个普通表没有任何不同，存储引擎也无须知道这是一个普通表还是一个分区表的一部分。

在分区表上的操作按照下面的操作逻辑进行：

select查询：

当查询一个分区表的时候，分区层先打开并锁住所有的底层表，优化器判断是否可以过滤部分分区，然后再调用对应的存储引擎接口访问各个分区的数据

insert操作：

当写入一条记录时，分区层打开并锁住所有的底层表，然后确定哪个分区接受这条记录，再将记录写入对应的底层表

delete操作：

当删除一条记录时，分区层先打开并锁住所有的底层表，然后确定数据对应的分区，最后对相应底层表进行删除操作

update操作：

当更新一条数据时，分区层先打开并锁住所有的底层表，mysql先确定需要更新的记录在哪个分区，然后取出数据并更新，再判断更新后的数据应该放在哪个分区，然后对底层表进行写入操作，并对原数据所在的底层表进行删除操作

**虽然每个操作都会打开并锁住所有的底层表，但这并不是说分区表在处理过程中是锁住全表的，如果存储引擎能够自己实现行级锁，如：innodb，则会在分区层释放对应的表锁，这个加锁和解锁过程与普通Innodb上的查询类似。**

## 分区类型
类型|简介
-|-
Range分区|利用取值范围进行分区，区间要连续并且不能互相重叠。
LIST分区|建立离散的值列表告诉数据库特定的值属于哪个分区
Columns分区|MySQL5.5中引入的分区类型，解决了5.5版本之前range分区和list分区只支持整数分区的问题。 Columns分区可以细分为 range columns分区和 list columns分区，他们都支持整数，日期时间，字符串三大数据类型。(不支持text和blob类型作为分区键) columns分区还支持多列分区(这里不详细展开)。
Hash分区|主要用来分散热点读，确保数据在预先确定个数的分区中尽可能平均分布
Key分区|类似Hash分区，Hash分区允许使用用户自定义的表达式，但Key分区不允许使用用户自定义的表达式。Hash仅支持整数分区，而Key分区支持除了Blob和text的其他类型的列作为分区键。


### Range分区
```sql
create table emp(
	id INT NOT null,
	store_id int not null
) partition by range(store_id)(
	partition p0 values less than(10),
	partition p1 values less than(20)
);
```
可用`explain`查看分区，比如`explain partitions select * from emp where store_id=10`可看到`prtitions`是`p1`。

**每个分区都是按顺序定义的，从最低到最高。**

**当插入的记录中对应的分区键的值不在分区定义的范围中的时候，插入语句会失败**

### LIST分区
```sql
create table emp1(
	id INT NOT null,
	store_id int not null
) partition by list(store_id)(
	partition p0 values in (3,5),
	partition p1 values in (2,6,7,9)
);
```
**如果插入的记录对应的分区键的值不在list分区指定的值中，将会插入失败！**

### Hash分区
#### 常规Hash分区
```sql
create table emp1(
	id INT NOT null,
	store_id int not null
) partition by hash(store_id) partitions 4; # 根据store_id对4取模，决定记录存储位置
```
优点：能够使数据尽可能的均匀分布。

缺点：不适合分区经常变动的需求。比如：增加两个分区，需要所有重新计算。
#### 线性Hash分区
```sql
create table emp1(
	id INT NOT null,
	store_id int not null
) partition by LINER hash(store_id) partitions 4;
```
算法：

假设要保存记录的分区编号为N,num为一个非负整数,表示分割成的分区的数量，那么N可以通过以下步骤得到：

Step 1. 找到一个大于等于num的2的幂，这个值为V，V可以通过下面公式得到：

V = Power(2,Ceiling(Log(2,num)))

例如：刚才设置了4个分区，num=4，Log(2,4)=2,Ceiling(2)=2,power(2,2)=4,即V=4

Step 2. 设置N=F(column_list)&(V-1)

例如：刚才V=4，store_id=234对应的N值，N = 234&(4-1) =2

Step 3. 当N>=num,设置V=Ceiling(V/2),N=N&(V-1)

例如：store_id=234,N=2<4,所以N就取值2，即可。

假设上面算出来的N=5，那么V=Ceiling(2.5)=3,N=234&(3-1)=1,即在第一个分区。

**优点：在分区维护(增加，删除，合并，拆分分区)时，MySQL能够处理得更加迅速。**

**缺点：与常规Hash分区相比，线性Hash各个分区之间的数据分布不太均衡。**

### KEY分区
```sql
create table emp1(
	id INT NOT null,
	store_id int not null
) partition by key(store_id) partitions 4;
```
和HASH分区相似,但是KEY分区支持除text和BLOB之外的所有数据类型的分区，而HASH分区只支持数字分区，KEY分区不允许使用用户自定义的表达式进行分区，KEY分区使用系统提供的HASH函数进行分区。当表中存在主键或者唯一键时，如果创建key分区时没有指定字段系统默认会首选主键列作为分区字列,如果不存在主键列会选择非空唯一键列作为分区列,注意唯一列作为分区列唯一列不能为null。

## 其他概念
### 子分区
分区表中对每个分区再次分割，又成为复合分区。

### 分区对于NULL值的处理
MySQ允许分区键值为NULL，分区键可能是一个字段或者一个用户定义的表达式。一般情况下，MySQL在分区的时候会把NULL值当作零值或者一个最小值进行处理。

注意

Range分区中：NULL值被当作最小值来处理

List分区中：NULL值必须出现在列表中，否则不被接受

Hash/Key分区中：NULL值会被当作零值来处理

### 分区管理
```sql
# 增加分区
alter table emp add partition (partition p2 values less than(30));
# 删除分区
alter table emp drop partition p2;
# 对于Hash和Key分区
alter table emp2 coalesce partition 2; //将分区缩减到2个
# 查询某张表一共有多少个分区
select partition_name,partition_expression,partition_description,table_rows
from INFORMATION_SCHEMA.partitions
where table_schema='test' and table_name = 'emp';
# 查看执行计划，判断查询数据是否进行了分区过滤
explain partitions select * from emp1 where store_id=3;
```

## 参考文章
1. [百万级数据mysql分区](https://www.cnblogs.com/fengwenzhee/p/7001207.html)
2. [mysql分区表之一：分区原理和优缺点【转】](https://www.cnblogs.com/duanxz/p/6518846.html)
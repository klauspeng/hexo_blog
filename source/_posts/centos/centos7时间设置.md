---
title: Centos7时间设置
date: 2018/8/8
categories: centos
---

Centos 7 时间设置 timedatectl
<!-- more -->

1. `date`命令查看时间及时区
2. `timedatectl [status]`命令查看时区及时间
```shell
 Local time: Tue 2017-12-12 09:11:18 EST
  Universal time: Tue 2017-12-12 14:11:18 UTC
        RTC time: Tue 2017-12-12 14:11:19
       Time zone: America/New_York (EST, -0500)
     NTP enabled: n/a
NTP synchronized: no
 RTC in local TZ: no
      DST active: no
 Last DST change: DST ended at
                  Sun 2017-11-05 01:59:59 EDT
                  Sun 2017-11-05 01:00:00 EST
 Next DST change: DST begins (the clock jumps one hour forward) at
                  Sun 2018-03-11 01:59:59 EST
                  Sun 2018-03-11 03:00:00 EDT
```
3. 更改时区 `timedatectl set-timezone Asia/Shanghai`
4. 设置硬件时间 `timedatectl set-local-rtc 1`
5. 启用时间同步 `timedatectl set-ntp yes`
我这报错了，是`ntp`未安装，直接`yum -y install ntp`，再试即可。

---

`timedatectl`效果如下：
```shell
      Local time: Tue 2017-12-12 22:25:19 CST
  Universal time: Tue 2017-12-12 14:25:19 UTC
        RTC time: Tue 2017-12-12 22:25:18
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: yes
      DST active: n/a
```

`date`效果如下：
```shell
Tue Dec 12 22:26:58 CST 2017
```

---
title: LNMP环境搭建--Centos7
date: 2017/9/21
categories: centos
---

在Centos7环境安装LAMP环境，备忘哈哈。

<!-- more -->

## 准备
首先去官网下载php，nginx

## 编译安装php
### 安装依赖
```shell
yum -y install epel-release
yum -y install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel
```

### 编译参数
```shell
./configure \
--prefix=/usr/local/php \
--with-config-file-path=/etc \
--enable-fpm \
--with-fpm-user=nginx  \
--with-fpm-group=nginx \
--enable-inline-optimization \
--disable-debug \
--disable-rpath \
--enable-shared  \
--enable-soap \
--with-libxml-dir \
--with-xmlrpc \
--with-openssl \
--with-mcrypt \
--with-mhash \
--with-pcre-regex \
--with-sqlite3 \
--with-zlib \
--enable-bcmath \
--with-iconv \
--with-bz2 \
--enable-calendar \
--with-curl \
--with-cdb \
--enable-dom \
--enable-exif \
--enable-fileinfo \
--enable-filter \
--with-pcre-dir \
--enable-ftp \
--with-gd \
--with-openssl-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib-dir  \
--with-freetype-dir \
--enable-gd-native-ttf \
--enable-gd-jis-conv \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-json \
--enable-mbstring \
--enable-mbregex \
--enable-mbregex-backtrack \
--with-libmbfl \
--with-onig \
--enable-pdo \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-zlib-dir \
--with-pdo-sqlite \
--with-readline \
--enable-session \
--enable-shmop \
--enable-simplexml \
--enable-sockets  \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-wddx \
--with-libxml-dir \
--with-xsl \
--enable-zip \
--enable-mysqlnd-compression-support \
--with-pear \
--enable-fastcgi \
--enable-opcache
```
### 安装
`make && make install`

### 配置环境变量
```shell
vim /etc/profile
# 末尾追加
export PATH=/usr/local/php/bin:$PATH
source /etc/profile
php -v #应该能看到php版本信息
```
### 配置php-fpm  需要在安装软件包目录
```shell
cp php.ini-production /etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod a+x /etc/init.d/php-fpm
```

### 增加用户组和用户
```shell
groupadd nginx
useradd -g nginx nginx
```
### 启动php-fpm
`/etc/init.d/php-fpm start`

### 开机启动
```shell
# 加入服务
chkconfig --add php-fpm
# 开机自启	    
chkconfig php-fpm on
```

## 安装nginx
### 安装依赖
```shell
yum -y install gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
```

### 编译
```shell
./configer
make && make install
```

### 关闭防火墙(可选)
```shell
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
```

### 开机启动
[脚本](http://blog.csdn.net/zc474235918/article/details/51794083?foxhandler=RssReadRenderProcessHandler)
```shell
chmod a+x /etc/init.d/nginx
chkconfig --add nginx
chkconfig nginx on
```

## 安装mysql
```shell
## 安装
yum -y install mariadb mariadb-server
# 启动mariadb
systemctl start mariadb 
# 开机自启动
systemctl enable mariadb 
# 设置 root密码等相关
mysql_secure_installation 
```


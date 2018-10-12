---
title: php-fpm 和 nginx 的两种通信方式
date: 2018/10/12
categories: php
---

tcp socket or unix socket?

<!-- more -->

## tcp socket
允许通过网络进程之间的通信，也可以通过loopback进行本地进程之间通信。

## unix socket
允许在本地运行的进程之间进行通信。
1. 需在同一台服务器
2. 将sock文件放在/dev/shm目录下，使用的内存读写更快。
```shell
# cd /dev/shm
touch php7.0-fpm.sock 
chown www-data:www-data php7.0-fpm.sock
chmod 777 php7.0-fpm.sock

# vi /etc/php/7.0/fpm/pool.d/www.conf
listen= /dev/shm/php7.0-fpm.sock
listen.owner = www-data
listen.group = www-data

# nginx配置
location ~* \.php$ {
    fastcgi_pass unix:/dev/shm/php7.0-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include /etc/nginx/fastcgi_params;
}
```



## 如何选择？
如果是在同一台服务器上运行的nginx和php-fpm，并发量不超过1000，选择unix socket，因为是本地，可以避免一些检查操作(路由等)，因此更快，更轻。 

如果我面临高并发业务，我会选择使用更可靠的tcp socket，以负载均衡、内核优化等运维手段维持效率。



参考链接：
1. [nginx和php-fpm 是使用 tcp socket 还是 unix socket ？](https://blog.csdn.net/qq624202120/article/details/60957634)
2. [nginx和php-fpm的通信方式有两种，一种是TCP的方式，一种是unix socket方式，哪种好一点？](https://segmentfault.com/q/1010000009961896)
3. [nginx 与 php-fpm socket 所有者权限问题](https://segmentfault.com/q/1010000002412399)
4. [nginx、php-fpm默认配置与性能–TCP socket还是unix domain socket](https://www.cnxct.com/default-configuration-and-performance-of-nginx-phpfpm-and-tcp-socket-or-unix-domain-socket/)



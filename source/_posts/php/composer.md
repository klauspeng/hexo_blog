---
title: composer笔记
date: 2017/4/25
categories: php
---

是 PHP 用来管理依赖（dependency）关系的工具。你可以在自己的项目中声明所依赖的外部工具库（libraries），Composer 会帮你安装这些依赖的库文件。
<!-- more -->
## [官网](http://www.phpcomposer.com/)

## 简介
依赖管理，不是包管理器  
声明依赖关系： 创建composer.json的文件  
```json
{
    "require": {
        "monolog/monolog": "1.2.*"
    }
}
```
运行`composer install`即可  
![](https://github.com/klauspeng/notes/raw/master/img/composer.png)

## 自动加载
除了库的下载，Composer 还准备了一个自动加载文件，它可以加载 Composer 下载的库中所有的类文件。  
使用它，你只需要将下面这行代码添加到你项目的引导文件中：
```php
require 'vendor/autoload.php';
```

## 命令行
1. 初始化 init - - 参数
2. 安装 install - - 参数
3. 更新 update - - 参数
4. 申明依赖 require - - 参数
5. 全局执行 global
6. 搜索 search - - 参数
7. 展示 show - - 参数
8. 依赖性检测 depends - - 参数
9. 有效性检测 validate
10. 依赖包状态检测 status
11. 自我更新 self-update - - 参数
12. 更改配置 config - - 使用方法 - - 参数 - - 修改包来源
13. 创建项目 create-project - - 参数
14. 打印自动加载索引 dump-autoload - - 参数
15. 查看许可协议 licenses
16. 执行脚本 run-script
17. 诊断 diagnose
18. 归档 archive - - 参数
19. 获取帮助信息 help

## 包版本
名称|实例
-|-
确切版本号| `1.0.2`
区间| `>=1.0,<1.1` 
通配符 | `1.0.*` 相当于 `>=1.0,<1.1`
赋值运算符 | `~1.2` 相当于 `>=1.2,<2.0` (指定最低版本,允许版本号的最后一位数字上升) <br> `^0.3` 相当于 `>=0.3.0,<0.4.0`

## 优化自动加载
`composer dump-autoload --optimize`

转换 PSR-0/4 autoloading 到 classmap 可以获得更快的加载支持。
特别是在生产环境下建议这么做，但由于运行需要一些时间，因此并没有作为默认值。


## 全局配置镜像
官方： `composer config -g repo.packagist composer https://packagist.org`

中国： `composer config -g repo.packagist composer https://packagist.phpcomposer.com`

## 增加自定义命名空间
```json
"autoload": {
  "psr-4" : {
    "Commands\\" : "app/commands"
  },
   "psr-0" : {
    "Commands" : "app/commands"
  }
}
```
运行命令：`composer dumpautoload`

## 自动引入文件
```json
"autoload": {
  "files" : {
    "/path/to/file/function.php"
  }
}
```

## 加速--linux
[prestissimo](https://github.com/hirak/prestissimo)

虚拟机自测 556s->168s! 效果还不错~

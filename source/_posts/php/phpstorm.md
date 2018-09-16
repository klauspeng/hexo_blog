---
title: PHPStorm 常用配置及问题
date: 2017/6/30
categories: 
---

## 设置Terminal字体
在Editor->Colors & Fonts -> Console Font设置

## 取消注释斜体
[参考文章](http://www.cnblogs.com/pthlp/p/6440556.html)

## 多个项目不同版本控制
> File->settings->Version Control->点➕，添加对应的项目即可

## git设置
Path to Git executable:`D:\Program Files (x86)\Git\cmd\git.exe`

ssh: settings-->Version Control-->Git ,and then, In the SSH executable dropdown, choose Native

## 激活
[参考文章](http://blog.csdn.net/hywerr/article/details/72084061)

## 单行注释设置
方法里面的单行注释我喜欢，根据方法缩进，并且与`//`之后有一个空格，有点强迫症，哈哈！  

设置如下：

1. Setting->Editor->Code Style->PHP->Wrapping and Braces->勾选掉Comment at first column 
2. Setting->Editor->Code Style->PHP->Other->Comment Code->勾选掉Line comment at first column，并勾选中Add a space at comment start

效果如下：  
![单行注释效果](https://github.com/klauspeng/notes/raw/master/img/phpstorm_comment.png)

## 快捷键
快捷键 | 功能 | 备注
---|---|---
Ctrl+Alt+O | 去除无用`use`,让代码更整洁 | 

## 插件
[翻译插件](https://github.com/YiiGuxing/TranslationPlugin)
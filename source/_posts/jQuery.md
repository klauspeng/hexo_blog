---
title: jQuery1.11.0学习笔记
date: 2018-1-1
tags:
  - js
categories: js
---
# jQuery1.11.0学习笔记
## 与JavaScript相比，jQuery的优缺点
与JavaScript相比，jQuery的语法更加简单。通过jQuery，可以很容易地浏览文档、选择元素、处理事件以及添加效果等，同时还允许开发者定制插件。

> 优点：

1. 轻量级
2. 强大的选择器
3. 出色的DOM操作封装
4. 完善的事件和事件对象兼容机制
5. 完善的ajax
6. 不污染全局变量，$可以随时交出控制权
7. 出色的浏览器兼容
8. 方便的链式操作
9. 隐式迭代（一般不需要for循环遍历dom对象）
10. 完善的文档
11. 丰富的插件

> 缺点：

1. 不向后兼容
2. 插件兼容
3. 插件之间的冲突
4. 对动画的支持一般

## $(document).ready()与window.onload的区别
1. 执行时机 onload-等所有资源加载完毕后执行 ready-等dom树加载完毕后就可以执行
2. 编写个数 onload-只能写一个 ready-可以多个
3. 简化写法 onload-不能 ready-$(fuction(){})

## jQuery对象与DOM对象
### jQuery对象转换DOM对象
1. 使用index方法
2. 使用get()方法
```js
var input = $("#a");
//jq获取
alert(input.val());
//1.使用index方法
alert(input[0].value);
//2.使用get()方法
alert(input.get(0).value);
```
### DOM对象转换jQuery对象
> 用$()把DOM对象包装器来就OK了

### jquery与其他js共存
> 使用jQuery.noConfict()方法释放$的权

##　jquery选择器








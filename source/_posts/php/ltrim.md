---
title: ltrim有意思的应用
date: 2017/9/26
categories: php
---

最近看文档，发现ltrim有第二个参数，可以自定义，应用其实可以很多。
<!-- more -->

## php文档
`string ltrim ( string $str [, string $character_mask ] )`

通过参数 character_mask，你也可以指定想要删除的字符，简单地列出你想要删除的所有字符即可。使用..，可以指定字符的范围。

`trim`,`rtrim`也是类似的
### 提取字符串首个数值
```php
var_dump(intval(ltrim('aaaASSASD121222212wewe', "A..z")));
# 121222212
```

### 去除首尾的数字
```php
var_dump(trim('121222212wewe12212', "0..9"));
# wewe
```

### 去除部分字符
```php
var_dump(ltrim('Hello world', 'Hdle')); 
# o world
```
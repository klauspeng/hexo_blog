---
title: 如何统计php-fpm的进程数？
date: 2018/10/10
categories: php
---

如何统计php-fpm的进程数？
<!-- more -->

## wc统计
```php
ps -ef|grep php |wc -l # 20
```

最终还要减1，不知道有没有更好的方法？

## wc解析
wc(Word Count) 统计指定文件中的字节数、字数、行数，并将统计结果显示输出.

-c 统计字节数。

-l 统计行数。

-m 统计字符数。这个标志不能与 -c 标志一起使用。

-w 统计字数。一个字被定义为由空白、跳格或换行字符分隔的字符串。

-L 打印最长行的长度。

-help 显示帮助信息

--version 显示版本信息
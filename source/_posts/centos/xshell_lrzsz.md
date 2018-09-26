---
title: xshell 上传与下载文件
date: 2018/5/7
categories: centos
---

下载上传文件的时候老得用xftp，可不可以直接xshell上传下载呢？
<!-- more -->

需先安装 `yum install lrzsz -y`
### 下载文件到本地
`sz file`就会弹出保存本地的对话框

### 上传文件到当前目录
`rz` 弹出对话框，选择上传的文件即可

`rz -y` 覆盖上传
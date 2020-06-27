---
title: 使用VsCode进行golang远程开发
comment:
  - false
categories:
  - [Golang]
  - [IDE]
tags:
  - vscode
photos:
  - https://img.bizhiku.net/uploads/2020/0406/vn3ypdn5gwb.jpg?x-oss-process=style/w_870-h_870
date: 2020-06-27 21:10:06
---

本文介绍如何利用`vscode`在远程`Linux`主机上进行开发, 使得PC机运行压力减小。这对于配置不好的PC机而言，是一个巨大的减负，把编程环境丢在服务机上，纵使换电脑也不需要重新安装环境。

<!-- more -->

## 前言

最近发现自己的笔记本有点卡，于是决定把开发环境移到远程主机上，本机只要开一个`vscode`进行`ssh`连接和文件编辑就可以。再也不用在自己的PC上安装`golang`，`java`，`python`之类的，全都推到`remote`，还有代码也放在`remote`上，用`github`托管。


## 安装vscode插件

名称 `Remote-SSH`
![远程开发插件](https://s1.ax1x.com/2020/06/27/NckklT.png)

## ssh连接远程主机

安装插件完成后，在`vscode`左侧的状态栏会出现一个显示器图标，里面就是远程主机，点击，然后点击齿轮，最后打开显示的输入框下的 `.ssh\config` 文件。

![远程开发步骤1](https://s1.ax1x.com/2020/06/27/NckEXF.png)

文件内有三个字段需要输入，注意，这里 `hostname`才是ip地址。
![config文件](https://s1.ax1x.com/2020/06/27/Nckm79.png)

输入完成后出现密码框，此时已经`ssh`到`home`下，随便打开一个文件夹作为项目，这里需要你再一次输入密码，接下来我们接受如何免密登录。

## 免密登录

如果之前给PC机配置过`github`的，那么在你PC机上的`.ssh`文件夹下有着一份 `id_rsa.pub`文件，（之前没配置过的话，打开pc命令行，输入`ssh-keygen -t rsa`即可），打开它，复制里面的内容，拷贝到`remote`的.ssh文件下的`authorized_keys`文件内（没有的话新建一个就可以了）。最后重启vscode。
![key](https://s1.ax1x.com/2020/06/27/Ncke0J.png)

**至此，我们完成了ssh的部分**。

## 远端golang环境配置

（这里就不解释怎么在`Linux`上安装`golang`了）
我们随便选择一个`remote`上的文件夹作为项目，然后右侧的插件市场标志。

![remote插件](https://s1.ax1x.com/2020/06/27/NckZm4.png)

我们需要选择一部分插件安装，比如`golang`必备的`vscode-go`插件等等，点击插件，他会显示是否需要在`remote`上安装（我这里已经安装完了）。

*对于没有科学上网的同学，先看下补充部分的说明，设置go代理，或者手动`git clone`插件仓库，在本地配置。*

然后打开settings.json,把里面的`go.gopath`,`go.goroot`,等等字段改为`remote`上的配置，（使用go env查看）。修改完后，`vscode`会提醒你需要安装`gotools`，点击` install all`即可。

## 补充

如果没有科学上网的话，建议现在`remote`上设置以下`goproxy`,比如的配置是：

```
GOPROXY="https://goproxy.cn,direct"
```
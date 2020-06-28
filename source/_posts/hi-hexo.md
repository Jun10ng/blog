---
title: hexo集成gitbook建站
date: 2020-06-27 14:42:38
comment:
    - false
categories:
	- website
tags:
	- hexo
	- markdown
photos:
	- https://i.kinja-img.com/gawker-media/image/upload/c_scale,f_auto,fl_progressive,q_80,w_1600/18pqg147h0hx3png.png
---


本文介绍了为何选择hexo，以及如何集成gitbook来构建个人博客，与自动部署脚本的使用。

<!-- more -->

## 弃用wordpress

最早，我在腾讯云上使用`wordpress`搭建个博客，但是由于以下几个原因，我选择放弃了它。

### MarkDown与备份难

`wordpress`对于的`markdown`的支持并不好，对于我这样一个MD重度使用者而言，太难受了，我也用过一小工具，使得你可以编辑完`markdown`文件后直接发布到`wordpress`上，但是这样的话，你没办法设置分类，文章特色图片等，等于被阉割了。

无法使用`markdown`的另一个缺点就是**备份困难**，我更喜欢只备份文稿，而不是备份整个网站。云存储空间的价格太昂贵了。
我的日常编辑器是`VSCode`，我对他做了很多“定制化”，现在使用起来得心应手，如果我能使用它编写文章，那最好不过。而不是去使用`wordpress`那个土里土气的编辑器。

### 插件安装与安全性

`wordpress`需要安装一堆插件以保证你网站的安全性，而我的主机是在国内，对于很多插件而言，安装速度很慢，甚至有时都打不开插件市场。但是如果不安装安全插件，你怎么能保证你的“小博客”在被非法分子的扫描下能活下来呢？

*这不是小概率事件，不要以为你是小博客就没人扫描你，我的大学室友的“死鱼塘博客”就曾经因为暴露一个文件上传接口，而被上传了一个恶意文件，现在扫描成本很低，甚至是为了玩而入侵的。*

`wordpress`还有一个为人诟病的地方就是他的评论区。各种非法评论，我就不说了。

### 占用内存和外观

比起`hugo`和`hexo`这些静态网站，`wordpress`的占用内存高得离谱，安装成本也高，需要世界上最好的语言`php`和`mysql`。
何况我还把这台主机当初我的远程开发机，这样的占用内存我有点不能忍。

`wordprss`的外观看起来有点不像个人网站，像是产品营销网站，因为很多这类产品都是用的`wordpress`建站，所以有一丝“油腻”。我还是更喜欢静态网站的简约。


说了这么多，正式进入我的`hexo`之旅吧。

## hexo

![hipaper原生](https://s1.ax1x.com/2020/06/27/N6FqC6.png)
我用的主题是[hipaper](https://github.com/iTimeTraveler/hexo-theme-hipaper/)，我选择的标准是：

* 简约黑白
* 代码高亮
* 图片支持

`hexo`的安装过程很简单，就是下载`node.js`，然后一条命令就好了，网上的教程很多，我就不重复了。接下来我说下我的搭建环境和自动部署脚本。

### 搭建环境

**我的`nginx`的`root`地址指向`public`文件夹。**

我在PC机上使用`VSCode`远程`ssh`到云主机上编写`markdown`文档，(不知道怎么使用`VSCode`远程开发的可以看下我的[这篇文章](http://jun10ng.work/2020/06/27/vscode-remote-development-and-golang-env/))，然后直接发布。并且在发布的同时`push`到`GitHub`上备份。

### 自动部署脚本

我写了一个小脚本实现了以上的工作流程，(我`GitHub`内的部署脚本包括了`gitbook的布置流程`)，如果带有参数执行的话就是将参数作为`commit`信息，如果没有参数的话，就是简单的重新生成页面。主要是用来“魔改”主题后确认效果的。

把脚本放在网站根目录下，和`_config.yml`同级。
脚本如下：

```shell
#!/usr/bin/env bash
# heploy.sh
echo -e "清除旧文件"
hexo cl
echo -e "\t\t......OK\n正在【生成】静态页面"
hexo g 
# end git book
echo -e "\t\t......OK\n正在【发布】静态页面"
hexo d 

if [ -z "$1" ];
then
# $1为空只更新静态网页，不git提交
    echo "更新完毕"
else
    git add .  
    echo -e "\t\t......OK\n执行git-commit"
    git commit -m "$1" 
    git push  
    echo -e "\t\t......OK\n执行git-push"

    echo "发布完成"
fi

```

## 集成gitbook

我的一些文章，想收录成书，方便查阅，所以我打算在个人博客中“集成”`gitbook`。这个集成其实就是把`gitbook`生成的静态文件转移到`hexo`的`public`文件夹中。

### 新建书本

`gitbook`安装过程我也不重复了，搜一下很多。

首先在你的网站根目录新建一个文件夹`book`，其中的每个子文件夹都等于一本书。

比如我新建一本*gdpcp*：其中的`book.sh`是自动部署脚本，待会儿会介绍。

![gdpcp](https://s1.ax1x.com/2020/06/28/NRt974.png)

然后你在子文件夹中`gitbook init`，至此，书算是新建成功了，接下来讲讲**如何集成**。

我们先了解下**手动部署过程**，首先在子文件夹中，执行`gitbook build`生成子文件夹，然后把生成的`_book`改名，转移到`public`文件夹中（比如改成`gbook`），这样你就可以在`http://xxxx.com/book`访问到书了。

而`public`这个文件夹在执行`hexo clean;hexo g`时都会被重新生成，顺带着`gbook`文件夹每次都会被删除，所以`gitbook build`命令要在每次`public`重生成后执行。如果没有使用`nginx`的话，还要在`hexo s`之前执行。

### 自动部署  

我们先看下如何`gitbook`的自动部署脚本，然后我们再把他集成到`hexo`的自动部署脚本中。
执行这个脚本后，会自动把生成的静态页面文件夹，也就是`gbook`，转移到`public`中。

```shell
#!/bin/bash
cd book

source=../public/book
for dir in *;
do
  #删除gitbook生成的内容
  if [ -d $source/$dir ]; then
    rm -r $source/$dir
  fi
  #重新生成gitbook的内容
  if [ -d $dir ]; then
    gitbook build $dir $source/$dir
  fi
done
```

然后我们在`hexo`部署脚本中使用这个脚本，完整脚本见[这里](https://github.com/Jun10ng/blog/blob/master/heploy.sh)，所以每次生成站点时，都会重新生成`gitbook`。

### 添加博客入口

这一小节介绍如何在`hexo`首页，添加书的入口，比如我的首页导航栏中的**[系列文章](http://jun10ng.work/books/)**，其实就是`gitbook`的入口。

首先，在改动导航栏，在主题的`yml`文件的`menu`中添加`books`字段（自定义），然后如果是使用汉字导航栏（比如我），还需要在`themes\<主题>\languages\zh-CN.yml`文件中添加`books`的相应字段翻译。
![](https://s1.ax1x.com/2020/06/28/NRaSnf.png)

接下来生成对应页面，执行`hexo new page books`，然后`source`内会生成一个`books`文件夹，里面的`index.md`可以自行编辑，比如我，加了一个书名然后指向我生成的`gitbook`地址，就是`public`内的`book`文件夹地址。

## 后记

文章写得有些仓促，如果有不明白的地方，欢迎到`github`留言或者发送邮件给我，邮件地址见[这里](http://jun10ng.work/about)。
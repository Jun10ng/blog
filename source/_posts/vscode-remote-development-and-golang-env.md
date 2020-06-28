---
title: VSCode配置与Golang远程开发
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

记录下自己的`VSCode`配置和`Golang` & `Java` 远程开发环境，方便将来换电脑的时候快速适配。

<!-- more -->

## 前言

本文分为两部分，一是`VSCode`的个人设置，二是远程开发环境配置。

我现在已经把开发环境全部推到了远程主机上了。哪怕换电脑，也只需要通过`Sync`插件同步一下`VSCode`，十分钟就能快速进行开发。


## 主题选择

![我的VSCode截图](https://s1.ax1x.com/2020/06/28/N2jhfU.png)

我选择了一个**偏暖色系**的主题(Tiny Light)，而不是大多人所选择的暗黑主题，**因为，暗黑主题容易让人眼干，假如你在看久了黑色界面，转而看其他东西会很难受，因此，我查阅资料后，选择了一个比较护眼的主题，事实也证明，这款主题让我眼睛舒服了很多。**

大多人选择暗黑主题真的是因为黑色舒服吗？还是心理觉得程序员就应该“黑+绿”编程才显得酷呢？

## 快捷键设置

几个比较个人的快捷键就是：我把自定义了方向键的快捷键，**使得我编程中，不需要过度移动右手来调整光标位置**，
，加上`end`键的使用，能满足大部分需求，特别是代码补全时不需要去按向下方向键。

`ALT + I` ：向上方向键
`ALT + K` ：向下方向键
`ALT + L` ：向左方向键
`ALT + J` ：向右方向键

*如果你有想实现的快捷命令，可以看下我的另一篇文章，介绍了如何利用插件实现多条命令的快捷键。*

### 配置

找到快捷键设置文件，粘贴复制即可。

```json
// + alt+ i j k l 代替上下左右键
    {
        "key": "alt+j",
        "command": "cursorLeft"
    },
    {
        "key": "alt+j ",
        "command": "list.collapse",
        "when": "listFocus"
    },
    {
        "key": "alt+k",
        "command": "cursorDown"
    },
    {
        "key": "alt+k",
        "command": "repl.action.historyNext",
        "when": "editorTextFocus && inDebugRepl && onLastDebugReplLine"
    },
    {
        "key": "alt+k",
        "command": "settings.action.focusSettingsFile",
        "when": "inSettingsSearch"
    },
    {
        "key": "alt+k",
        "command": "showNextParameterHint",
        "when": "editorTextFocus && parameterHintsMultipleSignatures && parameterHintsVisible"
    },
    {
        "key": "alt+k",
        "command": "selectNextSuggestion",
        "when": "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible"
    },
    {
        "key": "alt+k",
        "command": "keybindings.editor.focusKeybindings",
        "when": "inKeybindings && inKeybindingsSearch"
    },
    {
        "key": "alt+k",
        "command": "keybindings.editor.focusKeybindings",
        "when": "inKeybindings && inKeybindingsSearch"
    },
    {
        "key": "alt+k",
        "command": "search.focus.nextInputBox",
        "when": "inputBoxFocus && searchViewletVisible"
    },
    {
        "key": "alt+k",
        "command": "workbench.action.interactivePlayground.arrowDown",
        "when": "interactivePlaygroundFocus && !editorTextFocus"
    },
    {
        "key": "alt+l",
        "command": "cursorRight"
    },
    {
        "key": "alt+l",
        "command": "repl.action.acceptSuggestion",
        "when": "editorTextFocus && inDebugRepl && suggestWidgetVisible"
    },
    {
        "key": "alt+l",
        "command": "list.expand",
        "when": "listFocus"
    },
    {
        "key": "alt+i",
        "command": "cursorUp"
    },
    {
        "key": "alt+i",
        "command": "repl.action.historyPrevious",
        "when": "editorTextFocus && inDebugRepl && onLastDebugReplLine"
    },
    {
        "key": "alt+i",
        "command": "showPrevParameterHint",
        "when": "editorTextFocus && parameterHintsMultipleSignatures && parameterHintsVisible"
    },
    {
        "key": "alt+i",
        "command": "selectPrevSuggestion",
        "when": "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible"
    },
    {
        "key": "alt+i",
        "command": "list.focusUp",
        "when": "listFocus"
    },
    {
        "key": "ctrl+alt+i",
        "command": "search.action.focusSearchFromResults",
        "when": "firstMatchFocus && searchViewletVisible"
    },
    {
        "key": "alt+i",
        "command": "search.action.focusSearchFromResults",
        "when": "firstMatchFocus && searchViewletVisible"
    },
    {
        "key": "alt+i",
        "command": "workbench.action.interactivePlayground.arrowUp",
        "when": "interactivePlaygroundFocus && !editorTextFocus"
    },
    {
        "key": "ctrl+alt+l",
        "command": "breadcrumbs.focusNext",
        "when": "breadcrumbsActive && breadcrumbsVisible"
    },
    {
        "key": "ctrl+right",
        "command": "-breadcrumbs.focusNext",
        "when": "breadcrumbsActive && breadcrumbsVisible"
    },
    {
        "key": "ctrl+alt+l",
        "command": "breadcrumbs.focusNextWithPicker",
        "when": "breadcrumbsActive && breadcrumbsVisible && listFocus && !inputFocus"
    },
```


## 同步插件

[Setting Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
使用这个插件，会把你的`Setting.json`储存在`gist`中，你可以用`UPLOAD`更新它，用`DOWNLOAD`下载它。
十分方便。
**会自动帮你同步主题，快捷键，插件等一些东西。**
![](https://s1.ax1x.com/2020/06/28/NRSxUI.png)

## 远程开发配置

**本文就是在远程服务器上编写完成的，你可以仔细看看上一张图片，显示了我正`SSH`到远程主机。**

最近发现自己的笔记本有点卡，于是决定把开发环境移到远程主机上，本机只要开一个`vscode`进行`ssh`连接和文件编辑就可以。再也不用在自己的PC上安装`golang`，`java`，`python`之类的，全都推到`remote`，还有代码也放在`remote`上，用`github`托管。

### 安装vscode插件

名称 `Remote-SSH`
![远程开发插件](https://s1.ax1x.com/2020/06/27/NckklT.png)

### ssh连接远程主机

安装插件完成后，在`vscode`左侧的状态栏会出现一个显示器图标，里面就是远程主机，点击，然后点击齿轮，最后打开显示的输入框下的 `.ssh\config` 文件。

![远程开发步骤1](https://s1.ax1x.com/2020/06/27/NckEXF.png)

文件内有三个字段需要输入，注意，这里 `hostname`才是ip地址。
![config文件](https://s1.ax1x.com/2020/06/27/Nckm79.png)

输入完成后出现密码框，此时已经`ssh`到`home`下，随便打开一个文件夹作为项目，这里需要你再一次输入密码，接下来我们接受如何免密登录。

### 免密登录

如果之前给PC机配置过`github`的，那么在你PC机上的`.ssh`文件夹下有着一份 `id_rsa.pub`文件，（之前没配置过的话，打开pc命令行，输入`ssh-keygen -t rsa`即可），打开它，复制里面的内容，拷贝到`remote`的.ssh文件下的`authorized_keys`文件内（没有的话新建一个就可以了）。最后重启vscode。
![key](https://s1.ax1x.com/2020/06/27/Ncke0J.png)

**至此，我们完成了ssh的部分**。

### 远端golang环境配置

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
---
title: VsCode自定义"多条命令"的快捷键
date: 2020-06-27 18:06:37
tags: vscode
comment:
    - false
categories:
    - IDE
    - 工作效率
photos:
	- https://s1.ax1x.com/2020/06/27/N6RRJO.jpg
---

本文介绍了如何在vscode中自定义快捷键, 以及使用插件实现自定义"多条命令"的快捷键.

<!-- more -->

## 前言

vscode自定义快捷键基本格式如下

```
{
    "key": "",
    "command": "",
    //when可省略
    "when": ""
    }
```

其中command只能有一条指令，如果我现在要一个快捷键运行两个指令，并不能实现，所以要安装一个 macros的插件。

macros的指令格式如下

```
"macros": {
        "指令名称": [
           	“指令一”
            "指令二"
        ]
    }
```

## 例子

我现在要实现一个功能，按下  `ctrl`+`m` +`ctrl`+`go`可快速实现在md文档内输出go的代码格式如下,且光标还在第二行

```
​```go

​```
```

## 设置

首先在 *settings.json*z中添加一些设置

```json
"macros": {
    	// 自定义指令名称
        "goCode": [
            {//这个是第一个指令，输入文本
                "command": "type",
                "args": {
                    "text": "```go\n\n```"
                }
            },
            //第二个指令，光标上移
            "cursorUp"
        ]
    }
```

然后打开快捷键json文件，添加快捷键

```json
    {
        "key": "ctrl+m ctrl+g",
        "command": "macros.goCode",
        "when": "editorTextFocus && markdownShortcuts:enabled"
    }
```


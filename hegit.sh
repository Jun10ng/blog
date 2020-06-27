#!/usr/bin/env bash
cd /root/JunlongRemotw/github/blog/

echo -e "清除旧文件"
hexo cl > /dev/null
echo -e "\t\t......OK\n正在【生成】静态页面"
hexo g  > /dev/null
echo -e "\t\t......OK\n正在【发布】静态页面"
hexo d > /dev/null
echo -e "\t\t......OK\n将源文件添加到git版本库"
git add .  > /dev/null
echo -e "\t\t......OK\n添加GitComment"
git commit -m '`date  +"%Y-%m-%d %H:%M.%S 发布文章:$1"`'  > /dev/null
git push  > /dev/null
echo -e "\t\t......OK\n正在GitPush推送源文件"
cd -  > /dev/null
echo "发布完成"


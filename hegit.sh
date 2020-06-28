#!/usr/bin/env bash

echo -e "清除旧文件"
hexo cl
echo -e "\t\t......OK\n正在【生成】静态页面"
hexo g 
# gitbook
echo -e "\t\t......OK\n正在处理gitbook文件夹"
sh book/book.sh
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




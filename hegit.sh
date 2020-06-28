#!/usr/bin/env bash
echo -e "清除旧文件"
hexo cl
echo -e "\t\t......OK\n正在【生成】静态页面"
hexo g 
echo -e "\t\t......OK\n正在【发布】静态页面"
hexo d 
echo -e "\t\t......OK\n将源文件添加到git版本库"
git add .  
echo -e "\t\t......OK\n执行git-commit"
git commit -m "$1" 
git push  
echo -e "\t\t......OK\n执行git-push"

echo "发布完成"


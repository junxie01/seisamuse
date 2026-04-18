#!/bin/bash

# 部署脚本 - 自动构建并推送到GitHub

echo "=== 开始部署网站 ==="

# 1. 进入网站目录
cd "$(dirname "$0")"

echo "当前目录: $(pwd)"

# 2. 构建网站
echo "构建网站..."
python3 build.py

if [ $? -ne 0 ]; then
    echo "构建失败，退出部署"
    exit 1
fi

echo "构建成功！"

# 3. 检查Git仓库是否初始化
if [ ! -d ".git" ]; then
    echo "初始化Git仓库..."
    git init
    # 使用SSH地址
    git remote add origin git@github.com:junxie01/seisamuse.git
    echo "Git仓库初始化完成"
fi

# 4. 添加所有文件
echo "添加文件到Git..."
git add .

# 5. 提交更改
COMMIT_MESSAGE="更新网站 $(date +"%Y-%m-%d %H:%M:%S")"
echo "提交更改: $COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

# 6. 推送到GitHub
echo "推送到GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo "=== 部署成功！==="
    echo "网站已更新到: https://www.seis-jun.xyz/"
else
    echo "=== 部署失败！==="
    exit 1
fi

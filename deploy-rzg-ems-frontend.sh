#!/bin/bash
Backup_time=$(date '+%Y%m%d%H%M')
git_pull_path=/u01/rzg-ems-frontend
npm_compile_path=/u01/rzg-ems-frontend/rzg-ems-frontend
cd $git_pull_path
git pull origin master
if [ $? -ne 0 ]; then
    echo "无法拉取代码,退出"
    exit 1
fi






cd $npm_compile_path
npm install --registry=https://mirrors.huaweicloud.com/repository/npm/
if [ $? -ne 0 ]; then
    echo "安装依赖失败，退出"
    exit 1
fi

npm run prod
if [ $? -ne 0 ]; then
    echo "编译失败，退出"
    exit 1
fi


echo "########################"
echo  "     正在备份前端文件。。。。。。     "
echo "########################"
mkdir -p /u01/htmlbak/$Backup_time
\cp -rf  /usr/share/nginx/html  /u01/htmlbak/$Backup_time

echo "########################"
echo  "     正在更新前端。。。。。。。     "
echo "########################"
\cp -rf  dist/*    /usr/share/nginx/html
if [ $? -ne 0 ]; then
    echo "更新失败"
    exit 1
else 
    echo "更新成功"
fi
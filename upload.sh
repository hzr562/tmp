#!/bin/bash
if [ ! $1 ]; then
    echo "正确使用：  sh upload.sh exploy.war "
    exit 1
fi

echo "正在上传 。。。。。。。"
curl -X PUT -s -u admin:155xyjadmin#  -T  $1    http://112.74.92.155:8086/repository/test/$1
if [ $? -ne 0 ]; then
    echo "上传失败"
    exit 1
else
   echo "上传成功"
fi

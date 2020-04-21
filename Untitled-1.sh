#!/bin/bash
if [ -f /usr/share/nginx/html/dist.zip ]; then
    echo "文件存在"
    sleep 10
    unzip -o /usr/share/nginx/html/dist.zip -d  /usr/share/nginx/html/
    if [ $? == 0 ]; then
        rm -f /usr/share/nginx/html/dist.zip
        echo "更新失败：`date '+%Y%m%d %H:%M:%S'`" > /usr/share/nginx/html/latest

    else
        echo "更新失败：`date '+%Y%m%d %H:%M:%S'`" > /usr/share/nginx/html/latest
    fi


else
    echo "文件不存在"
fi

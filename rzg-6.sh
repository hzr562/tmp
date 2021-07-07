#!/bin/bash

projects=/opt/rzg-update/protal/rzg-portal-parent
packet_name=rzg-rzg-portal-api-1.0.0-SNAPSHOT.jar






if [ ! $1 ]; then  
   echo "error Script"
   echo "sh deploy_rzg_ems.sh dev"
   exit 1
fi  

cd  $projects


git checkout  $1  && git pull origin $1
if [ $? -ne 0 ]; then
    echo "无法拉取代码,退出"
    exit 1
fi

mvn clean install -U  -P test
if [ $? -ne 0 ]; then
    echo "编译失败，退出"
    exit 1
fi

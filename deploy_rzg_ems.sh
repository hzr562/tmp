#!/bin/bash

projects=/opt/rzg-ems/rzg-ems-parent
packet_name=rzg-ems-api-2.0.0-SNAPSHOT.jar
packet_name_path=$projects/rzg-ems-api/target/$packet_name  #启动包的路径
port=7060


if [ ! $1 ]; then  
   echo "error Script"
   echo "sh deploy_rzg_ems.sh dev"
   exit 1
fi  

cd  $projects


git pull origin $1
if [ $? -ne 0 ]; then
    echo "无法拉取代码,退出"
    exit 1
fi

mvn clean install -U
if [ $? -ne 0 ]; then
    echo "编译失败，退出"
    exit 1
fi


ps aux| grep $packet_name | grep -v grep| cut -c 9-15| xargs kill -9
#ps aux| grep $packet_name_path | grep -v grep| cut -c 9-15| xargs kill -9
sleep 4
nohup java -jar -Duser.timezone=GMT+08 $packet_name_path &



# for i in 3 2 1
# do
#   sleep 1
#   echo $i 秒后打印启动日志  请以启动日志判断项目启动情况！！！
# done
# tail -fn 200 /opt/rzg-ems/rzg-ems-parent/nohup.out
while [ ! -n "$web" ]
do     
       i=$(($i+1))
       echo "$packet_name正在启动"
       sleep 10
       web=`lsof -i:$port`
       if [[ i -ge 7 ]];
       then
          echo "发版失败，详细到/opt/rzg-ems/rzg-ems-parent/nohup.out 查看启动日志"
          exit 1
       fi
       
done
echo "启动成功"
echo  "程序启动时间"  `ps aux| grep $packet_name_path | grep -v grep| awk  '{print$9} END {print$10}'`

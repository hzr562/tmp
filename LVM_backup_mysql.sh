#!/bin/bash
export LC_ALL="en_US.UTF8"
back_dir=/backup/`date "+%Y-%m-%d_%H_%M_%S"`
[ -d $back_dir ] || mkdir -p $back_dir
MYSQL_USER=root
MYSQL_passwd=666666
mysqladmin -u$MYSQL_USER -p$MYSQL_passwd ping &>/dev/null
if [ $? -eq 0 ];then
   echo "mysql is up"
else
   echo "mysql is down"
   exit 1
fi

mysql -u$MYSQL_USER -p$MYSQL_passwd -e 'flush table with read lock'
#/dev/centos/mysql 查看lvdisplay
lvcreate --snapshot /dev/centos/mysql -n data-snap --size 1G --permission r
# -n data-snap 快照名称
mysql -u$MYSQL_USER -p$MYSQL_passwd -e  'show master status' |grep mysql > $back_dir/position.txt
mysql -u$MYSQL_USER -p$MYSQL_passwd -e  'flush logs'
mysql -u$MYSQL_USER -p$MYSQL_passwd -e 'unlock tables'
mount -o nouuid,norecovery /dev/centos/data-snap  /mnt/
[[  $(mountpoint /mnt | grep -o  not) ]] && echo "挂载失败退出" && exit 1
#    匹配not     匹配到就退出
rsync -progD /mnt/ $back_dir
if [ $? -eq 0 ];then
umount -f /mnt/   
lvremove -f /dev/centos/data-snap &&  echo "已经卸载快照 备份于$back_dir">> /opt/back_info.txt
else
   echo "同步失败"
fi          


#保留30天
del_backup_dir=/backup
cd $del_backup_dir
if [ $? = 0 ]; then
        find ./ -type f -mtime +30 -exec rm -rf {} \; >/dev/null 2>&1
fi     
           
             
###lvm快照之后  挂载快照再复制备份  然后删除快照

#!/bin/bash
Backup_time=$(date '+%Y%m%d%H%M%S')
backup_path=/opt/soft/backup_ems/$Backup_time
ems8080=/opt/ems1/ems8080/webapps
ems8081=/opt/ems1/ems8081/webapps
ems2=/opt/ems2/ems2-web-2.0.0-SNAPSHOT.jar
ems2_statistics=/opt/ems2-statistics/ems2-statistics-web-2.0.0-SNAPSHOT.jar
ems_mobile=/opt/ems-mobile/ems-mobile-web-1.0-SNAPSHOT.jar
nginx_forunt=/usr/share/nginx
nginx_config=/etc/nginx/conf.d/ems2.conf

mkdir -p  $backup_path  $backup_path/ems1/8080   $backup_path/ems1/8081  $backup_path/ems2           $backup_path/ems2-statistics     $backup_path/ems-mobile



src=($ems8080 $ems8081  $ems2   $ems2_statistics $ems_mobile  $nginx_forunt  $nginx_config)
dest=($backup_path/ems1/8080  $backup_path/ems1/8081  $backup_path/ems2   $backup_path/ems2-statistics  $backup_path/ems-mobile   $backup_path     $backup_path  )
for i in `seq 0 6`;do
       echo "正在备份    ${src[i]}  到 ${dest[i]}"
       \cp -rpf  ${src[i]}  ${dest[i]}
done







#!/bin/bash -ex
source config-after-neutron.cfg

# brex_address=`/sbin/ifconfig br-ex | awk '/inet addr/ {print $2}' | cut -f2 -d ":"`
# MASTER=$brex_address

###################
echo "########## CAI DAT DASHBOARD ##########"
###################
sleep 5

echo "########## Cài đặt Dashboard ##########"
apt-get -y install openstack-dashboard memcached && dpkg --purge openstack-dashboard-ubuntu-theme


echo "########## Cau hinh fix loi cho apache2 ##########"
sleep 5
# Fix loi apache cho ubuntu 14.04
 echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
sudo a2enconf servername 
# echo "ServerName localhost" >> /etc/apache2/httpd.conf


echo "########## Tao trang redirect ##########"

filehtml=/var/www/html/index.html
test -f $filehtml.orig || cp $filehtml $filehtml.orig
rm $filehtml
touch $filehtml
cat << EOF >> $filehtml
<html>
<head>
<META HTTP-EQUIV="Refresh" Content="0.5; URL=http://$MASTER/horizon">
</head>
<body>
<center> <h1>Dang chuyen den Dashboard cua OpenStack</h1> </center>
</body>
</html>
EOF

# Cho phep chen password tren dashboad ( chi ap dung voi image tu dong )
sed -i "s/'can_set_password': False/'can_set_password': True/g" /etc/openstack-dashboard/local_settings.py

## /* Khởi động lại apache và memcached
service apache2 restart
service memcached restart
echo "########## Hoan thanh cai dat Horizon ##########"

echo "########## THONG TIN DANG NHAP VAO HORIZON ##########"
echo "URL: http://$MASTER/horizon"
echo "User: admin hoac demo"
echo "Password:" $ADMIN_PASS


#!/bin/bash
yum -y update
yum -y upgrade
amazon-linux-extras install nginx1 -y

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /usr/share/nginx/html/index.html
<html>
<h2> ${S_name} WEB Server with IP: $myip</h2>
<br> Build by Terraform
<br> ver. 0.2 (c) AG"
</html>
EOF
systemctl start nginx
chkconfig nginx on

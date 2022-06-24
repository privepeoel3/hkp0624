#!/bin/sh
 
if [[ -z "${TYPE}" ]]; then
  TYPE="vless"
fi
echo ${TYPE}

if [[ -z "${UUID}" ]]; then
  UUID="f8bfb621-6728-4a6c-ae69-2106cd3d7c8a"
fi
echo ${UUID}


mkdir /xraybin
cd /xraybin
RAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"
echo ${RAY_URL}
wget --no-check-certificate ${RAY_URL}
unzip Xray-linux-64.zip
rm -f Xray-linux-64.zip
chmod +x ./xray
ls -al

# cd /wwwroot
# tar xvf wwwroot.tar.gz
# rm -rf wwwroot.tar.gz

# Install Html
mkdir /wwwroot
wget -qO /tmp/html.zip ${Site} 
unzip -qo /tmp/html.zip -d /usr/share/nginx
rm -rf /tmp/html.zip

sed -e "/^#/d"\
    -e "s/\${UUID}/${UUID}/g"\
    -e "s/\${TYPE}/${TYPE}/g"\
    /conf/Xray.template.json >  /xraybin/config.json
echo /xraybin/config.json
cat /xraybin/config.json


sed -e "/^#/d"\
    -e "s/\${PORT}/${PORT}/g"\
    -e "s/\${UUID}/${UUID}/g"\
    -e "s/\${TYPE}/${TYPE}/g"\
    -e "$s"\
    /conf/nginx.template.conf > /etc/nginx/conf.d/ray.conf
echo /etc/nginx/conf.d/ray.conf
cat /etc/nginx/conf.d/ray.conf

cd /xraybin
./xray run -c ./config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'


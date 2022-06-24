#!/bin/sh
 
if [[ -z "${Vless_Path}" ]]; then
  Vless_Path="vlok"
fi
echo ${Vless_Path}

if [[ -z "${UUID}" ]]; then
  UUID="99abfe31-7eb5-44dc-a3ec-53e117323148"
fi
echo ${UUID}

if [[ -z "${Vmess_Path}" ]]; then
  Vmess_Path="vmok"
fi
echo ${Vmess_Path}


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
unzip -qo /tmp/html.zip -d /wwwroot 
rm -rf /tmp/html.zip

sed -e "/^#/d"\
    -e "s/\${UUID}/${UUID}/g"\
    -e "s|\${Vless_Path}|${Vless_Path}|g"\
    -e "s|\${Vmess_Path}|${Vmess_Path}|g"\
    /conf/Xray.template.json >  /xraybin/config.json
echo /xraybin/config.json
cat /xraybin/config.json


sed -e "/^#/d"\
    -e "s/\${PORT}/${PORT}/g"\
    -e "s|\${Vless_Path}|${Vless_Path}|g"\
    -e "s|\${Vmess_Path}|${Vmess_Path}|g"\
    -e "$s"\
    /conf/nginx.template.conf > /etc/nginx/conf.d/ray.conf
echo /etc/nginx/conf.d/ray.conf
cat /etc/nginx/conf.d/ray.conf

cd /xraybin
./xray run -c ./config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'


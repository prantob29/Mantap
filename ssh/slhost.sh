#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
apt install jq curl -y
mkdir -p /usr/bin/xray
mkdir -p /usr/bin/v2ray
mkdir -p /etc/xray
mkdir -p /etc/v2ray
echo "sub0.sshcloud.live" >> /etc/v2ray/domain
#
sub=$(</dev/urandom tr -dc a-z0-9 | head -c5)
subsl=$(</dev/urandom tr -dc a-z0-9 | head -c5)
DOMAIN=sshcloud.live
SUB_DOMAIN=sub0.sshcloud.live
NS_DOMAIN=sub1.sshcloud.live
CF_ID=prantousa@gmail.com
CF_KEY=1201d665086604f0732e74129bd65e903ca94
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for sub0.sshcloud.live..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=sshcloud.live&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=sub0.sshcloud.live" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"sub0.sshcloud.live","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"sub0.sshcloud.live","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Updating DNS NS for sub1.sshcloud.live..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=sshcloud.live&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=sub1.sshcloud.live" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"sub1.sshcloud.live","content":"sub0.sshcloud.live","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"sub1.sshcloud.live","content":"sub0.sshcloud.live","ttl":120,"proxied":false}')
rm -rf /etc/xray/domain
rm -rf /root/nsdomain
echo "IP=sub0.sshcloud.live" >> /var/lib/crot/ipvps.conf
echo "Host : sub0.sshcloud.live"
echo "sub0.sshcloud.live" > /root/domain
echo "Host SlowDNS : sub1.sshcloud.live"
echo "sub0.sshcloud.live" >> /root/nsdomain
echo "sub0.sshcloud.live" >> /etc/xray/domain
cd



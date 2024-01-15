#!/bin/bash
# By VP@20240112

pcapfile="dhcpack.pcap"
interval="600"

echo "移除舊有 PCAP"
rm "${pcapfile}" 2&>/dev/null
echo "於背景抓取 DHCP 封包"
tshark -i any -f "dst port 68" -c 1 -V -w "${pcapfile}"  &

sleep "${interval}"

if [ -f "${pcapfile}" ]
then
  echo DHCP 正常
else
  kill -9 $(pidof tshark)
  echo "沒收到 DHCP 封包，DHCP Server 正常？"
fi

# 來源 IP
echo "<DHCP 封包來源>"
tshark -V -r "${pcapfile}" -T fields -e ip.src

# DHCP 伺服器位置
#tshark -r "${pcapfile}" -T fields -e dhcp.option.dhcp_server_id

# DNS Server
echo "<DNS Server>"
tshark -V -r "${pcapfile}" -T fields -e dhcp.option.domain_name_server

# Local Domain Name
echo "<Local Domain Name>"
tshark -r "${pcapfile}" -T fields -e dhcp.option.domain_name

# RT
echo "<Local Domain Name>"
tshark -r "${pcapfile}" -T fields -e dhcp.option.router

# 廣播位置
#tshark -r "${pcapfile}" -T fields -e dhcp.option.broadcast_address

# 遮罩
echo "<mask>"
tshark -r "${pcapfile}" -T fields -e dhcp.option.subnet_mask

# 租約時間
echo "<租約時間>"
tshark -r "${pcapfile}" -T fields -e dhcp.option.ip_address_lease_time

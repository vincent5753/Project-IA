#!/bin/bash

network_result=""
nicwalkresult=$(snmpwalk -v 2c -c public "$targetip" 1.3.6.1.2.1.31.1.1.1.1)
# wc 計算行數
niccount=$(echo "$nicwalkresult" | wc -l)
niclist=$(echo "$nicwalkresult" | cut -d " " -f 4)

# 從target取得OID資訊，使用cut 用' '將每行字串切斷，並取到第四個索引的資料（從1開始）
# RX
rxresult=$(snmpwalk -v 2c -c public "$targetip" 1.3.6.1.2.1.31.1.1.1.6 | cut -d ' ' -f 4)
# TX
txresult=$(snmpwalk -v 2c -c public "$targetip" 1.3.6.1.2.1.31.1.1.1.10 | cut -d ' ' -f 4)
#echo "$niccount nics"
#echo "$niclist"

# 將每個網路介面迭代並印出nic/rx/tx
for i in $(seq 1 "$niccount")
do
  #echo $i
  # 將i行的結果印出
  curnic=$(echo "$niclist" | sed -n ${i}p)
  currx=$(echo "$rxresult" | sed -n ${i}p)
  curtx=$(echo "$txresult" | sed -n ${i}p)
  network_result="$network_result $curnic=$(jo RX=$currx TX=$curtx)"
  #echo "[Traffic] Nic: ${curnic}   RX: ${currx}   TX: ${curtx}"
done

ip_address=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
# 取得id跟cpu閒置率
# UCD-SNMP-MIB::ssCpuIdle.0 = INTEGER: 37

#step1:
cpuidle=$(snmpwalk -v 2c -c public 10.20.1.40 1.3.6.1.4.1.2021.11.11.0 | cut -d " " -f 4)

# 算出cpu以使用率
#step2:
cpuused=$(( 100 - $cpuidle ))
#echo "[SNMP-System-CPU] CPU_Usage: $cpuused %"

# 取得總記憶體量並減去已使用量，得到可使用量
#step3:
totalmem=$(snmpwalk -v 2c -c public 10.20.1.40 1.3.6.1.4.1.2021.4.5.0 | cut -d " " -f 4)
usedmem=$(snmpwalk -v 2c -c public 10.20.1.40 1.3.6.1.4.1.2021.4.6.0 | cut -d " " -f 4)
avaliblemem=$(( $totalmem - $usedmem ))

#echo "[SNMP-System-Memory] Totalmem: $totalmem   Usedmem: $usedmem   Avaliblemem: $avaliblemem"

jo -p $ip_address=$(jo cpu=$(jo usage=$cpuused ) memory=$(jo total=$totalmem user=$usedmem avalible=$avaliblemem) network=$(jo $network_result)) | jq


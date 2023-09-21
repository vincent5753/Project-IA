#!/bin/bash

# only tested on macos

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
end=$'\e[0m'

ua="Mozilla/5.0 (Linux; U; Linux i651 ; en-US) Gecko/20100101 Firefox/68.5"
baseurl="https://ithelp.ithome.com.tw/users"

# 日期
# mac 使用 gdate (brew install) ，Linux 直接 date 即可
specific_date="2023-09-04"
today_date=$(gdate +"%Y-%m-%d")

# 取得timestamp，mac 使用 gdate
specific_timestamp=$(gdate -d "$specific_date" +"%s")
today_timestamp=$(gdate -d "$today_date" +"%s")

# 計算差異
difference_seconds=$((today_timestamp - specific_timestamp))

# 轉換天數
difference_days=$((difference_seconds / 86400))

#echo "Days passed since $specific_date: $difference_days"
daysinironman=$(( difference_days + 1 ))
echo "鐵人第 $daysinironman 天"

someuser1='xxxxxxxx/ironman/xxxx'
someuser2='xxxxxxxx/ironman/xxxx'

for user in "someuser1" "someuser2" "someuser3" "someuser4"
do
    name="${user}name"
    result=$(curl -s --user-agent "$ua" "${baseurl}/${!user}")
    title=$(echo "$result" | grep "/title" | awk -F ">" '{print $2}' | awk -F " " '{print $1}' | sed 's/ //g')
    Days=$(echo "$result" | grep "參賽天數" | awk -F " " '{print $2}')
    if [ "$Days" == "$daysinironman" ]
    then
        curuser=$(printf "隊員: %-12s 參賽天數: ${grn}%-3s${end} 主題: ${yel}%-45s${end}" "${!name}" "$Days" "$title")
#        echo "$curuser"
        if [ "$user" == "someuser1" ]
        then
          L2msg="$curuser"
        elif [ "$user" == "someuser2" ]
        then
          L3msg="$curuser"
        elif [ "$user" == "someuser3" ]
        then
          L4msg="$curuser"
        elif [ "$user" == "someuser4" ]
        then
          L5msg="$curuser"
        fi
    else
        curuser=$(printf "隊員: %-12s 參賽天數: ${red}%-3s${end} 主題: ${yel}%-45s${end}" "${!name}" "$Days" "$title")
#        echo "$curuser"
        if [ "$user" == "someuser1" ]
        then
          L2msg="$curuser"
        elif [ "$user" == "someuser2" ]
        then
          L3msg="$curuser"
        elif [ "$user" == "someuser3" ]
        then
          L4msg="$curuser"
        elif [ "$user" == "someuser4" ]
        then
          L5msg="$curuser"
        fi
    fi
    sleep 0.1
done

echo "$L1msg"
echo "$L2msg"
echo "$L3msg"
echo "$L4msg"
echo "$L5msg"

bot_token='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
bot_chatID='xxxxxxxxxx'

bot_message=$(printf %s\\n "$L1msg" "$L2msg" "$L3msg" "$L4msg" "$L5msg" | jq -sRr @uri)
send_url="https://api.telegram.org/bot$bot_token/sendMessage?chat_id=$bot_chatID&parse_mode=HTML&text=$bot_message"
curl -X GET "$send_url"

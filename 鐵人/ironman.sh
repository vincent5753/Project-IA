#!/bin/bash

# only tested on macos

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
end=$'\e[0m'

ua="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
baseurl="https://ithelp.ithome.com.tw/users"

# 日期
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

for user in "someuser1" "someuser2"
do
    result=$(curl -s --user-agent "$ua" "${baseurl}/${!user}")
    title=$(echo "$result" | grep "/title" | awk -F ">" '{print $2}' | awk -F " " '{print $1}' | sed 's/ //g')
    Days=$(echo "$result" | grep "參賽天數" | awk -F " " '{print $2}')

    if [ "$Days" == "$daysinironman" ]
    then
        printf "使用者: %-12s 參賽天數: ${grn}%-3s${end} 主題: ${yel}%-45s${end}\\n" "$user" "$Days" "$title"
    else
        printf "使用者: %-12s 參賽天數: ${red}%-3s${end} 主題: ${yel}%-45s${end}\\n" "$user" "$Days" "$title"
    fi
    sleep 0.5

done

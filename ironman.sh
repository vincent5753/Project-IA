#!/bin/bash

grn=$'\e[1;32m'
yel=$'\e[1;33m'
end=$'\e[0m'

ua="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
baseurl="https://ithelp.ithome.com.tw/users"

someuser1='xxxxxxxx/ironman/xxxx'
someuser2='xxxxxxxx/ironman/xxxx'

for user in "someuser1" "someuser2"
do
    result=$(curl -s --user-agent "$ua" "${baseurl}/${!user}")
    title=$(echo "$result" | grep "/title" | awk -F ">" '{print $2}' | awk -F " " '{print $1}' | sed 's/ //g')
    Days=$(echo "$result" | grep "參賽天數" | awk -F " " '{print $2}')
    printf "使用者: %-12s 參賽天數: ${grn}%-3s${end} 主題: ${yel}%-45s${end}\\n" "$user" "$Days" "$title"
    sleep 0.5
done

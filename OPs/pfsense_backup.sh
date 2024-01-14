#!/bin/bash
# By VP@20240110
# ref: https://docs.netgate.com/pfsense/en/latest/backup/remote-backup.html

source credential.sh

# Fetch cookies and CSRF token
echo "Fetch cookies and CSRF token"
curl --silent -L -k --cookie-jar cookies.txt \
     http://${imac_vpn_ip}/ \
     | grep "name='__csrf_magic'" \
     | sed 's/.*value="\(.*\)".*/\1/' > csrf.txt
#cat csrf.txt


# Login
echo "Login"
curl --silent -L -k --cookie cookies.txt --cookie-jar cookies.txt \
     --data-urlencode "login=Login" \
     --data-urlencode "usernamefld=admin" \
     --data-urlencode "passwordfld=${imac_vpn_passwd}" \
     --data-urlencode "__csrf_magic=$(cat csrf.txt)" \
     http://${imac_vpn_ip}/ > /dev/null

# Fetch the target page to obtain a new CSRF token
echo "Fetch the target page to obtain a new CSRF token"
curl --silent -L -k --cookie cookies.txt --cookie-jar cookies.txt \
     http://${imac_vpn_ip}/diag_backup.php  \
     | grep "name='__csrf_magic'"   \
     | sed 's/.*value="\(.*\)".*/\1/' > csrf.txt

# Bakup!
# 記得備份 SSH Keys， 不然還原後每個使用者的 CA 都要重建
echo "Bakup!"
curl -L -k --cookie cookies.txt --cookie-jar cookies.txt \
     --data-urlencode "download=download" \
     --data-urlencode "backupdata=yes" \
     --data-urlencode "backupssh=yes" \
     --data-urlencode "__csrf_magic=$(head -n 1 csrf.txt)" \
     http://${imac_vpn_ip}/diag_backup.php > pfsense-config-`date +%Y%m%d%H%M%S`.xml

# Clean up
rm cookies.txt
rm csrf.txt

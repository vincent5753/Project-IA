#!/bin/bash

get_context_count (){
  context_count=$(cat ~/.kube/config | yq e '.contexts[].name' - | wc -l)
}

outputoption (){
  cat ~/.kube/config | yq e '.contexts[].name' - | awk '{print NR, ".", $0}'
}

selectoption (){
  read -p "[Act] 請選擇目標叢集(1-N) " numselected
  clustername=$(cat ~/.kube/config | yq e ".contexts[$(( $numselected -1 ))].name" -)
  echo "[Info] 選擇目標叢集為 $numselected $clustername"
}

fetch_token (){
  TOKEN=$(kubectl get secrets --context=$clustername -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)
  echo $TOKEN
}

get_credential (){
#  kcca=$(cat ~/.kube/config | yq ".clusters[$(( $numselected -1 ))].cluster.certificate-authority-data" | base64 -d -)
#  kcuser=$(cat ~/.kube/config | yq ".users[$(( $numselected -1 ))].user.client-certificate-data" | base64 -d -)
#  kcuk=$(cat ~/.kube/config | yq ".users[$(( $numselected -1 ))].user.client-key-data" | base64 -d -)
  cat ~/.kube/config | yq e ".clusters[$(( $numselected -1 ))].cluster.certificate-authority-data" - | base64 -d - > ca.pem
  cat ~/.kube/config | yq e ".users[$(( $numselected -1 ))].user.client-certificate-data" - | base64 -d - > user.pem
  cat ~/.kube/config | yq e ".users[$(( $numselected -1 ))].user.client-key-data" - | base64 -d - > user-key.pem
}

fetch_pod_list (){
  APISERVER=$(cat ~/.kube/config | yq e ".clusters[$(( $numselected -1 ))].cluster.server" -)
  ns="default"
  echo "$APISERVER"
#  curl -s --header "Authorization: Bearer $TOKEN" --insecure -X GET $APISERVER/api/v1/namespaces/$ns/pods?limit=50
  pod=$(curl -s --header "Authorization: Bearer $TOKEN" --insecure --cert ./user.pem --key ./user-key.pem --cacert ./ca.pem  -X GET $APISERVER/api/v1/namespaces/$ns/pods)
  numofpo=$(echo $pod | jq -c '.items | length')
  echo "Pod數量: $numofpo"
}

rm_credential (){
  rm ca.pem
  rm user.pem
  rm user-key.pem
}

get_context_count
echo "[Info] 目前於 ~/.kube/config 偵測到 $context_count 個叢集資訊"
outputoption
selectoption
get_credential
fetch_pod_list

read -p "[Act] 輸入開頭: " regexinput

for i in $(seq $numofpo)
do
  num4jq=$(echo $(( $i - 1 )))
#  echo $num4jq
  curponame=$(echo $pod | jq -r -c ".items["$num4jq"].metadata.name")
  echo "叢集: $clustername pod名稱: $curponame"

  if [[ "$curponame" =~ ^$regexinput ]]
  then
    echo "符合開頭的條件"
  else
    echo "不符合開頭的條件"
  fi

done

rm_credential

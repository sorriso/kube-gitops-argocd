#!/bin/bash

helm repo add https://charts.argo-cd
helm repo update
LIST=$(helm search repo argo-cd --versions | sed -n '2p')

FILE=./current.txt
# if file existe
if test -f "$FILE"; then
    echo '.file exist'
    CURRENT=$(cat ./current.txt)
    SIZE=${#CURRENT}
    #if variable is not empty
    if [ $CURRENT > 1 ]
    then
        echo '.  variable not empty'
        CURRENT=$(cat ./current.txt | sed -n '1p')
        #if current version is found in list
        if [[ "$LIST" == *"$CURRENT"* ]]; then
          echo '.      last version=yes'
          echo '.        update=no'
          UPDATE='NO'
        else
          echo '.      last version=no'
          echo '.        update=yes'
          UPDATE='YES'
        fi
    else
        echo '.  variable empty'
        echo '.    update=yes'
        UPDATE='YES'
    fi
else
    echo '.file NOT exist'
    echo '.  update=yes'
    UPDATE='YES'
fi

if [[ "$UPDATE" == 'YES' ]]; then
  echo 'Updating helm chart'
  rm -f *.tgz
  rm -Rf ./argo-cd
  helm pull bitnami/argo-cd
  helm pull bitnami/argo-cd --untar
  CURRENT=$(ls argo-cd-*.* | sed 's/argo-cd-//g' | sed 's/.tgz//g')
  echo $CURRENT > ./current.txt
  logDate=$(date '+%Y-%m-%d')
  echo "$logDate : update ArgosCD to $CURRENT" >> ./history.log
  cp -Rf ./customValues/values.yaml ./argo-cd/values.yaml
else
  echo "$logDate : No ArgosCD update needed" >> ./history.log
fi

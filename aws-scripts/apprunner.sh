#!/bin/zsh
. "$HOME/.zshrc"
set +x

source ./get-profiles.sh

for p in "${PROFILES[@]}"
do
  echo "Account: $p"
  echo "====="
  source ./get-regions.sh $p
  
  for r in "${REGIONS[@]}"
  do
    echo "Region: $r"
    IFS=$'\n' APPS=(`aws apprunner list-services --region $r --profile $p | jq -r -c '.ServiceSummaryList| .[] | .ServiceName'`)
    for a in ${APPS[@]}
    do
      echo "* AppRunner found: $a"
    done
  done
  echo "\n\n"
done


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
    IFS=$'\n' GWS=(`aws apigateway get-rest-apis --region $r --profile $p | jq -r -c '.items| .[] | .id + ": " + .name'`)
    for g in ${GWS[@]}
    do
      echo "* API Gateway found: $g"
    done
  done
  echo "\n\n"
done


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
    IFS=$'\n' STATEMACHINES=(`aws stepfunctions list-state-machines --region $r --profile $p | jq -r -c '.stateMachines| .[] | .name'`)
    for s in ${STATEMACHINES[@]}
    do
      echo "* State Machine found: $s"
    done
  done
  echo "\n\n"
done

